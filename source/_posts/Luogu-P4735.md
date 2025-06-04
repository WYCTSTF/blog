---
title: 洛谷P4735 最大异或和
tags:
    - 可持久化Trie
date: 2022-02-02
---

信誓旦旦的学了可持久化Trie和01Trie来搞，结果出了一点问题，被卡了好久

这篇算是可持久化Trie的笔记

<!-- more -->

先随便糊了一个暴力，用pre记一下异或前缀和，Xor表示异或总和

pre[i]^Xor就是 (i+1)~n的异或和

这么裸的一个暴力居然给了73分，11个点wa了3个点，
{% fold code %}
```cpp
int main() {
    n=read(),m=read();
    for (int i=1;i<=n;i++) {
        cin>>a[i]; Xor^=a[i];
        pre[i]=pre[i-1]^a[i];
    }
    char op;
    int l,r,x;
    for (int i=1;i<=m;i++) {
        cin>>op;
        if(op=='A') {
            x=read();
            a[++n]=x;
            Xor^=x;
            pre[n]=pre[n-1]^x;
        } else {
            int Max=0;
            l=read(), r=read(), x=read();
            for (int i=l; i<=r; i++) {
                Max=max(Max,pre[i-1]^Xor^x);
            }
            cout<<Max<<endl;
        }
    }
    return 0;
}
```
{% endfold %}

然后考虑做一点简单的优化，最好是能够像[最大异或数对](https://loj.ac/p/10050)那样维护一个01Trie，这样对于每个x都能速查

如果l=1,r=n，那么只要把全部的pre^Xor放到Trie里面，然后差x能取到的最大值

但是现在l,r是有变动的，所以我们要维护多版本的01Trie，只有一个端点还是比较简单的，但是两端都在动，怎么可持久化这问题就比较头疼

就是要找一个维护的方法，每次给出l,r,我们都能拿到由pre[l-1]^Xor  pre[l]^Xor  ... pre[r-1]^Xor构成的01Trie

或者说是拿到一个答案的时候，我们希望他在[l-1,r-1]的范围内

那么建一个可持久化Trie，设end[x]表示可持久化Trie的节点x是序列s中第几个二进制数末尾的节点

设latest[x]表示在可持久化Trie中以x为根的子树中end的最大值，从root[r-1]出发找答案的时候，只考虑latest值不小于l-1的节点

时间复杂度在$O((N+M)log10^7)$

数列里面插入一个0会比较好处理

{% fold code %}
```cpp
#include <bits/stdc++.h>
using namespace std;
const int N=600010;
int trie[N*24][2], latest[N*24];
int s[N], Root[N], n, m, tot;
void insert(int i, int k, int p, int q) { // 统计子树latest，所以用到递归插入
// 当前为s[i]的第k位
    if (k<0) {
        latest[q]=i;
        return ;
    }
    int c=s[i]>>k&1;
    if (p)
        trie[q][c^1]=trie[p][c^1]; // 这里子节点只有c和c^1，反正c要重新插入，会被覆盖，所以就只继承c^1了
    trie[q][c]=++tot;
    insert(i, k-1, trie[p][c], trie[q][c]);
    latest[q]=max(latest[trie[q][0]], latest[trie[q][1]]);
}
int ask(int now, int val, int k, int limit) {
    if (k<0) return s[latest[now]] ^ val;
    int c = val >> k & 1;
    if (latest[trie[now][c^1]]>=limit)
        return ask(trie[now][c^1], val, k-1, limit);
    else
        return ask(trie[now][c], val, k-1, limit);
}
int main() {
    cin>>n>>m;
    latest[0]=-1;
    Root[0]=++tot;
    insert(0, 23, 0, Root[0]);
    for (int i=1; i<=n; i++) {
        int x; cin >> x;
        s[i]=s[i-1]^x;
        Root[i]=++tot;
        insert(i, 23, Root[i-1], Root[i]);
    }
    for (int i=1; i<=m; i++) {
        char op[2]; scanf("%s", op);
        if (op[0]=='A') {
            int x; scanf("%d", &x);
            Root[++n]=++tot;
            s[n]=s[n-1]^x;
            insert(n,23,Root[n-1],Root[n]);
        } else {
            int l, r, x; scanf("%d%d%d", &l, &r, &x);
            cout << ask(Root[r-1], x^s[n], 23, l-1) << endl;
        }
    }
    return 0;
}
```
{% endfold %}

也可以在每次加入节点的时候将trie的这条链的权值+1

查询的时候判断一个节点是否存在，如果sum[r]-sum[l-1]=0，那么这个值，也就是这条链不是在[l,r]里面出现的，就不考虑

{% fold code %}
```cpp
#include<bits/stdc++.h>
using namespace std;
const int N=6e5+10;
int n,m,a[N],b[N],bin[30],Root[N];
struct Trie{
    int tot;
    int ch[N*24][2],sum[N*24];
    int insert(int x,int val){
        int tmp,y;tmp=y=++tot;
        for(int i=23;i>=0;i--)
        {
            ch[y][0]=ch[x][0]; ch[y][1]=ch[x][1];
            sum[y]=sum[x]+1;
            int t=val&bin[i];t>>=i;
            ch[y][t]=++tot;
            y=ch[y][t], x=ch[x][t];
        }
        sum[y]=sum[x]+1;
        return tmp;
    }
    int query(int l,int r,int val){
        int tmp=0;
        for(int i=23;i>=0;i--)
        {
            int t=val&bin[i];t>>=i;
            if(sum[ch[r][t^1]]-sum[ch[l][t^1]])
                tmp+=bin[i],r=ch[r][t^1],l=ch[l][t^1];
            else r=ch[r][t],l=ch[l][t];
        }
        return tmp;
    }
}trie;
int main()
{
    // cin.tie(nullptr)->sync_with_stdio(false);
    bin[0]=1;for(int i=1;i<30;i++) bin[i]=bin[i-1]<<1;
    cin>>n>>m;
    n++;
    for(int i=2;i<=n;i++) cin>>a[i];
    for(int i=1;i<=n;i++) b[i]=b[i-1]^a[i];
    for(int i=1;i<=n;i++)
        Root[i]=trie.insert(Root[i-1],b[i]);
    char ch[5];
    int l,r,x;
    while(m--)
    {
        scanf("%s", ch);
        if(ch[0]=='A'){
            n++;
            cin>>a[n];b[n]=b[n-1]^a[n];
            Root[n]=trie.insert(Root[n-1],b[n]);
        }else{
            cin>>l>>r>>x;
            cout<<trie.query(Root[l-1],Root[r],b[n]^x)<<endl;
        }
    }
    return 0;
}
```
{% endfold %}

我傻乎乎的关流之后cin和scanf看了好久的问题没看出来，多花了快一个小时，草了

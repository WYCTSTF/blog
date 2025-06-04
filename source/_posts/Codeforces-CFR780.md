---
title: Codeforces Round 780 (Div. 3)
tags: 
	- 树状数组
	- Codeforces
date: 2022-04-02
---

太菜了 上不了大分

愚人节的wa是Oops on test 2 呵呵呵呵

<!-- more -->

## F2. Promising String (hard version)

给定长为n≤200010的串 由+和-构成 每个“- -”可以变成+ 一个promising子串被指定是经过k≥0次“- -”变+后 +-数量相同 问一个串的合法子串数量

考虑一段区间内-数量和+数量 如果差值大于等于0并且%3等于0 那么这段区间就是promising的 差值可以用前缀和统计一下

中间想了一个歪掉的思路 就是前缀和变化幅度不超过1 然后试图用这个做些事 未遂

前缀和弄好了之后 我傻逼的脑抽了一下 我说把%3=0,1,2的数量分别统计一下区间端点 然后ans+=tot[i]*(tot[i-1])/2不就好了。。 然而这样就没有考虑差值$\geq 0$

那么事实上要插入的时候满足差值大于0 即前缀和p[r]-p[l-1]>=0 就是在按1->n的顺序拿的时候 统计前缀和比自身小的 模数相同的数量 才能计为贡献 这个过程就和树状数组求逆序对的操作一样 只是开了3倍空间考虑不同模数的数字

插入的时候因为是区间 前缀和要把p[0]考虑进去

```cpp
#include <bits/stdc++.h>
using namespace std;
using ll=long long;
const int N=200010,INF=0x7fffffff;
char ch;
int n,mx,mn,t[3][N],p[N];
void add(int k,int x,int v){
	for(;x<=mx;x+=x&-x) t[k][x]+=v;
}
int qry(int k,int x){
	int ans=0;
	for(;x;x-=x&-x) ans+=t[k][x];
	return ans;
}
int main(){
	ios_base::sync_with_stdio(false);
	cin.tie(nullptr);
	int tt; cin>>tt;
	while(tt--){
		int n;cin>>n;p[0]=mx=0;mn=INF;
		for(int i=1;i<=n;i++) {
			cin>>ch; p[i]=p[i-1]+((ch=='-')?1:-1);
			mn=min(mn,p[i]);
		}
		mn-=4; //权值>=1 不然/3的时候寄了
		for(int i=0;i<=n;i++) p[i]-=mn;
		for(int i=0;i<=n;i++) mx=max(mx,p[i]/3); // 权值树状数组上界范围
		for(int i=1;i<=mx;i++) t[0][i]=t[1][i]=t[2][i]=0;
		ll ans=0;
		add(p[0]%3,p[0]/3,1);
		for(int i=1;i<=n;i++){
			ans+=qry(p[i]%3,p[i]/3);
			add(p[i]%3,p[i]/3,1);
		}
		cout<<ans<<endl;
	}
}
```

## F2. Promising String (easy version)

n方暴力铸币都会写 嗯 我没写 我铸币不如..

就这么一个前缀和 然后$n^2$ 给它定1700分 消愁啊

## E. Matrix and Shifts

比赛的时候15min没Rush出来 因为没有看到主对角线这个说法 然后把要求输出的看错了。。

已经把眼角膜捐了 别讲了别讲了

剩下的就是 扫n条斜线 然后统计一个最小值 Min{n+ans-2*tot}

ans是1的数量 tot是对角线上1的数量

有个小Trick就是扩展到2n*2n的规模 然后就可以简单粗暴的写了

```cpp
#include <bits/stdc++.h>
using namespace std;
const int N=4010;
int n;
int a[N][N],sum[N][N],p[N][N];
int main() {
	ios_base::sync_with_stdio(false);
	cin.tie(nullptr);
	int tt;cin>>tt;
	string s;
	while(tt--){
		cin>>n;
		for(int i=1;i<=n;i++){
			cin>>s; for(int j=1;j<=n;j++) {
				a[i][j]=a[i+n][j]=a[i][j+n]=a[i+n][j+n]=(s[j-1]=='1'?1:0);
			}
		}
		for(int i=1;i<=n*2;i++){
			for(int j=1;j<=n*2;j++){
				sum[i][j]=sum[i-1][j]+sum[i][j-1]-sum[i-1][j-1]+a[i][j];
				p[i][j]=p[i-1][j-1]+a[i][j];
			}
		}
		int ans=n*n;
		for(int x=n;x<=2*n;x++)
			for(int y=n;y<=2*n;y++)
				ans=min(ans,sum[x][y]-sum[x-n][y]-sum[x][y-n]+sum[x-n][y-n]+n-2*(p[x][y]-p[x-n][y-n]));
		cout<<ans<<endl;
	}
	return 0;
}
```

## D. Maximum Product Strikes Back

因为空的是1 所以用0分割开来

然后每个小区间乘积统计一下 如果>0直接统计 |2| 的数量并更新

如果小于0 就判断从前面删到负数和从后面删到负数损失的|2| 取一个损失小的方法更新就好

写了有一会儿 码力不行啊..

{% fold code %}
```cpp
#include<bits/stdc++.h>
#define max(a,b) (a>b?a:b)
#define min(a,b) (a>b?b:a)
using namespace std;
const int N=200010;
int a[N];
int main() {
	ios_base::sync_with_stdio(false);
	cin.tie(nullptr);
	int tt;cin>>tt;
	queue<pair<int,int>>q;
	while(tt--){
		int n; cin>>n;
		for(int i=1;i<=n;i++) cin>>a[i];
		int st=1,now=1;
		while(st<=n){
			while(st<=n&&a[st]==0) st++; now=st;
			while(now<=n&&a[now]!=0) now++;
			q.push({st,now-1});
			st=now+1;
		}
		int Max=0,tl=n,tr=0;
		while(!q.empty()){
			int l=q.front().first,r=q.front().second; q.pop();
			int tot1=0,tot2=0; for(int i=l;i<=r;i++) {if(a[i]<0) tot1++; if(a[i]==2||a[i]==-2) tot2++;}
			if(tot1%2==0&&Max<tot2) Max=tot2,tl=l,tr=r;
			int tot3=0,tot4=0;
			int ql=l; while(a[ql]>0) ql++; for(int i=ql+1;i<=r;i++){if(a[i]==2||a[i]==-2) tot3++;}
			int qr=r; while(a[qr]>0) qr--; for(int i=l;i<qr;i++){if(a[i]==2||a[i]==-2) tot4++;}
			if(tot3>Max) Max=tot3,tl=ql+1,tr=r;
			if(tot4>Max) Max=tot4,tl=l,tr=qr-1;
		}
		if(Max==0) cout<<tl<<' '<<tr<<endl;
		else cout<<tl-1<<' '<<n-tr<<endl;
	}
	return 0;
}
```
{% endfold %}

## C. Get an Even String

卡了好久 nt了

只有一种情况要分析一下 就是怎么从g a d e d f g f中把ddff拿出来 而不是gg

{% fold fold %}
```cpp
#include<bits/stdc++.h>
using namespace std;
int main(){
	int tt;cin>>tt;
	stack<char>sta;
	string s;
	bool vis[30];
	while(tt--){
		memset(vis,false,sizeof(vis));
		cin>>s;
		int ans=0;
		for(int i=0;i<(int)(s.size());i++) {
			if(sta.empty()||vis[s[i]-'a']==false) sta.push(s[i]),vis[s[i]-'a']=true;
			else if(vis[s[i]-'a']==true){
				ans+=2; while(sta.empty()==false) sta.pop(); memset(vis,false,sizeof(vis));
			}
		}
		cout<<s.size()-ans<<endl;
	}
	return 0;
}
```
{% endfold %}

----

又tm的5点了 晚上效率说实话也不行..

昆明之前也不能完全这么操作 不然HP炸了玩个毛

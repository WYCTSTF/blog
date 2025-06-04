import os
import yaml

def test_main_config():
    with open('_config.yml', 'r') as f:
        cfg = yaml.safe_load(f)
    assert cfg.get('url'), 'Site URL should not be empty'
    assert cfg.get('theme') == 'landscape'

def test_posts_have_front_matter():
    for root, _, files in os.walk('source/_posts'):
        for name in files:
            if name.endswith('.md'):
                path = os.path.join(root, name)
                with open(path, 'r') as f:
                    first = f.readline().strip()
                assert first == '---', f'{path} missing front matter delimiter'


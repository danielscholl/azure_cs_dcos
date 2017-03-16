# Standard Application Installs

### Marathon

__External Marathon__

```bash
azureuser@dcos-master$ dcos package install --options=./apps/marathon-lb-external.json marathon-lb --yes
```

__Internal Marathon__
```bash
azureuser@dcos-master$ dcos package install --options=./apps/marathon-lb-internal.json marathon-lb --yes
```

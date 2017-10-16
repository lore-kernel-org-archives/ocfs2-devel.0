From: Gang He <ghe@suse.com>
Date: Sun, 15 Oct 2017 21:26:00 -0600
Subject: [Ocfs2-devel] [PATCH] ocfs2/cluster: make config_item_type const
In-Reply-To: <201710142029.1LNtJPOZ%fengguang.wu@intel.com>
References: <1507798192-20528-1-git-send-email-bhumirks@gmail.com>
	<201710142029.1LNtJPOZ%fengguang.wu@intel.com>
Message-ID: <59E49748020000F900092B3D@prv-mh.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lkp@intel.com
Cc: kbuild-all@01.org, bhumirks@gmail.com, julia.lawall@lip6.fr, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

Hello Intel Kbuild team,

You just upgrade GCC version when compiling the latest kernel? 
Since these code looks a little old, I am sure that the related contributors are still work on OCFS2 project.


Thanks
Gang


>>> 
> Hi Bhumika,
> 
> [auto build test WARNING on linus/master]
> [also build test WARNING on v4.14-rc4 next-20171013]
> [if your patch is applied to the wrong git tree, please drop us a note to 
> help improve the system]
> 
> url:    
> https://urldefense.proofpoint.com/v2/url?u=https-3A__github.com_0day-2Dci_l 
> inux_commits_Bhumika-2DGoyal_ocfs2-2Dcluster-2Dmake-2Dconfig-5Fitem-5Ftype-2Dconst_2
> 0171014-2D185701&d=DwIBAg&c=RoP1YumCXCgaWHvlZYR8PQcxBKCX5YTpkKY057SbK10&r=f4ohdmG
> rYxZejY77yzx3eNgTHb1ZAfZytktjHqNVzc8&m=8Ca3nktkbfrjbR5Spv4mvmdj2s377WohnG6h6z1
> WB7E&s=hFVfDC8STTMTIDNtdipf8BlwR_V8RJG6an_l-r9MKyA&e= 
> config: tile-allyesconfig (attached as .config)
> compiler: tilegx-linux-gcc (GCC) 4.6.2
> reproduce:
>         wget 
> https://urldefense.proofpoint.com/v2/url?u=https-3A__raw.githubusercontent.c 
> om_intel_lkp-2Dtests_master_sbin_make.cross&d=DwIBAg&c=RoP1YumCXCgaWHvlZYR8PQcxB
> KCX5YTpkKY057SbK10&r=f4ohdmGrYxZejY77yzx3eNgTHb1ZAfZytktjHqNVzc8&m=8Ca3nktkbfrj
> bR5Spv4mvmdj2s377WohnG6h6z1WB7E&s=f5lUGF9NCtygTaG6AR0HkjhG7fOwD5nKFLaYCvPpju0&e
> =  -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         make.cross ARCH=tile 
> 
> All warnings (new ones prefixed by >>):
> 
>    fs/ocfs2/cluster/nodemanager.c: In function 'o2nm_node_group_make_item':
>    fs/ocfs2/cluster/nodemanager.c:573:2: warning: passing argument 3 of 
> 'config_item_init_type_name' discards 'const' qualifier from pointer target 
> type [enabled by default]
>    include/linux/configfs.h:73:13: note: expected 'struct config_item_type 
> *' but argument is of type 'const struct config_item_type *'
>    fs/ocfs2/cluster/nodemanager.c: In function 
> 'o2nm_cluster_group_make_group':
>    fs/ocfs2/cluster/nodemanager.c:681:9: warning: passing argument 3 of 
> 'config_group_init_type_name' discards 'const' qualifier from pointer target 
> type [enabled by default]
>    include/linux/configfs.h:102:13: note: expected 'struct config_item_type 
> *' but argument is of type 'const struct config_item_type *'
>    fs/ocfs2/cluster/nodemanager.c:685:9: warning: passing argument 3 of 
> 'config_group_init_type_name' discards 'const' qualifier from pointer target 
> type [enabled by default]
>    include/linux/configfs.h:102:13: note: expected 'struct config_item_type 
> *' but argument is of type 'const struct config_item_type *'
>    fs/ocfs2/cluster/nodemanager.c: In function 'o2nm_depend_item':
>    fs/ocfs2/cluster/nodemanager.c:743:2: warning: passing argument 1 of 
> 'configfs_depend_item' discards 'const' qualifier from pointer target type 
> [enabled by default]
>    include/linux/configfs.h:269:5: note: expected 'struct configfs_subsystem 
> *' but argument is of type 'const struct configfs_subsystem *'
>    fs/ocfs2/cluster/nodemanager.c: In function 'exit_o2nm':
>    fs/ocfs2/cluster/nodemanager.c:785:2: warning: passing argument 1 of 
> 'configfs_unregister_subsystem' discards 'const' qualifier from pointer 
> target type [enabled by default]
>    include/linux/configfs.h:253:6: note: expected 'struct configfs_subsystem 
> *' but argument is of type 'const struct configfs_subsystem *'
>    fs/ocfs2/cluster/nodemanager.c: In function 'init_o2nm':
>    fs/ocfs2/cluster/nodemanager.c:808:2: warning: passing argument 1 of 
> 'config_group_init' discards 'const' qualifier from pointer target type 
> [enabled by default]
>    include/linux/configfs.h:101:13: note: expected 'struct config_group *' 
> but argument is of type 'const struct config_group *'
>>> fs/ocfs2/cluster/nodemanager.c:809:2: warning: passing argument 1 of 
> '__mutex_init' discards 'const' qualifier from pointer target type [enabled 
> by default]
>    include/linux/mutex.h:133:13: note: expected 'struct mutex *' but 
> argument is of type 'const struct mutex *'
>    fs/ocfs2/cluster/nodemanager.c:810:2: warning: passing argument 1 of 
> 'configfs_register_subsystem' discards 'const' qualifier from pointer target 
> type [enabled by default]
>    include/linux/configfs.h:252:5: note: expected 'struct configfs_subsystem 
> *' but argument is of type 'const struct configfs_subsystem *'
>    fs/ocfs2/cluster/nodemanager.c:820:2: warning: passing argument 1 of 
> 'configfs_unregister_subsystem' discards 'const' qualifier from pointer 
> target type [enabled by default]
>    include/linux/configfs.h:253:6: note: expected 'struct configfs_subsystem 
> *' but argument is of type 'const struct configfs_subsystem *'
> 
> vim +809 fs/ocfs2/cluster/nodemanager.c
> 
> 0c83ed8e Kurt Hackel       2005-12-15  740  
> 14829422 Joel Becker       2007-06-14  741  int o2nm_depend_item(struct 
> config_item *item)
> 14829422 Joel Becker       2007-06-14  742  {
> 14829422 Joel Becker       2007-06-14 @743  	return 
> configfs_depend_item(&o2nm_cluster_group.cs_subsys, item);
> 14829422 Joel Becker       2007-06-14  744  }
> 14829422 Joel Becker       2007-06-14  745  
> 14829422 Joel Becker       2007-06-14  746  void o2nm_undepend_item(struct 
> config_item *item)
> 14829422 Joel Becker       2007-06-14  747  {
> 9a9e3415 Krzysztof Opasiak 2015-12-11  748  	configfs_undepend_item(item);
> 14829422 Joel Becker       2007-06-14  749  }
> 14829422 Joel Becker       2007-06-14  750  
> 16c6a4f2 Joel Becker       2007-06-19  751  int o2nm_depend_this_node(void)
> 16c6a4f2 Joel Becker       2007-06-19  752  {
> 16c6a4f2 Joel Becker       2007-06-19  753  	int ret = 0;
> 16c6a4f2 Joel Becker       2007-06-19  754  	struct o2nm_node *local_node;
> 16c6a4f2 Joel Becker       2007-06-19  755  
> 16c6a4f2 Joel Becker       2007-06-19  756  	local_node = 
> o2nm_get_node_by_num(o2nm_this_node());
> 16c6a4f2 Joel Becker       2007-06-19  757  	if (!local_node) {
> 16c6a4f2 Joel Becker       2007-06-19  758  		ret = -EINVAL;
> 16c6a4f2 Joel Becker       2007-06-19  759  		goto out;
> 16c6a4f2 Joel Becker       2007-06-19  760  	}
> 16c6a4f2 Joel Becker       2007-06-19  761  
> 16c6a4f2 Joel Becker       2007-06-19  762  	ret = 
> o2nm_depend_item(&local_node->nd_item);
> 16c6a4f2 Joel Becker       2007-06-19  763  	o2nm_node_put(local_node);
> 16c6a4f2 Joel Becker       2007-06-19  764  
> 16c6a4f2 Joel Becker       2007-06-19  765  out:
> 16c6a4f2 Joel Becker       2007-06-19  766  	return ret;
> 16c6a4f2 Joel Becker       2007-06-19  767  }
> 16c6a4f2 Joel Becker       2007-06-19  768  
> 16c6a4f2 Joel Becker       2007-06-19  769  void o2nm_undepend_this_node(void)
> 16c6a4f2 Joel Becker       2007-06-19  770  {
> 16c6a4f2 Joel Becker       2007-06-19  771  	struct o2nm_node *local_node;
> 16c6a4f2 Joel Becker       2007-06-19  772  
> 16c6a4f2 Joel Becker       2007-06-19  773  	local_node = 
> o2nm_get_node_by_num(o2nm_this_node());
> 16c6a4f2 Joel Becker       2007-06-19  774  	BUG_ON(!local_node);
> 16c6a4f2 Joel Becker       2007-06-19  775  
> 16c6a4f2 Joel Becker       2007-06-19  776  
> 	o2nm_undepend_item(&local_node->nd_item);
> 16c6a4f2 Joel Becker       2007-06-19  777  	o2nm_node_put(local_node);
> 16c6a4f2 Joel Becker       2007-06-19  778  }
> 16c6a4f2 Joel Becker       2007-06-19  779  
> 16c6a4f2 Joel Becker       2007-06-19  780  
> 0c83ed8e Kurt Hackel       2005-12-15  781  static void __exit exit_o2nm(void)
> 0c83ed8e Kurt Hackel       2005-12-15  782  {
> 0c83ed8e Kurt Hackel       2005-12-15  783  	/* XXX sync with hb callbacks and 
> shut down hb? */
> 0c83ed8e Kurt Hackel       2005-12-15  784  	o2net_unregister_hb_callbacks();
> 0c83ed8e Kurt Hackel       2005-12-15  785  
> 	configfs_unregister_subsystem(&o2nm_cluster_group.cs_subsys);
> 0c83ed8e Kurt Hackel       2005-12-15  786  	o2cb_sys_shutdown();
> 0c83ed8e Kurt Hackel       2005-12-15  787  
> 0c83ed8e Kurt Hackel       2005-12-15  788  	o2net_exit();
> 87d3d3f3 Sunil Mushran     2008-12-17  789  	o2hb_exit();
> 0c83ed8e Kurt Hackel       2005-12-15  790  }
> 0c83ed8e Kurt Hackel       2005-12-15  791  
> 0c83ed8e Kurt Hackel       2005-12-15  792  static int __init init_o2nm(void)
> 0c83ed8e Kurt Hackel       2005-12-15  793  {
> 0c83ed8e Kurt Hackel       2005-12-15  794  	int ret = -1;
> 0c83ed8e Kurt Hackel       2005-12-15  795  
> 87d3d3f3 Sunil Mushran     2008-12-17  796  	ret = o2hb_init();
> 87d3d3f3 Sunil Mushran     2008-12-17  797  	if (ret)
> 87d3d3f3 Sunil Mushran     2008-12-17  798  		goto out;
> 2309e9e0 Sunil Mushran     2008-04-14  799  
> 2309e9e0 Sunil Mushran     2008-04-14  800  	ret = o2net_init();
> 2309e9e0 Sunil Mushran     2008-04-14  801  	if (ret)
> 87d3d3f3 Sunil Mushran     2008-12-17  802  		goto out_o2hb;
> 0c83ed8e Kurt Hackel       2005-12-15  803  
> 0c83ed8e Kurt Hackel       2005-12-15  804  	ret = 
> o2net_register_hb_callbacks();
> 0c83ed8e Kurt Hackel       2005-12-15  805  	if (ret)
> 3878f110 Joel Becker       2008-05-30  806  		goto out_o2net;
> 0c83ed8e Kurt Hackel       2005-12-15  807  
> 0c83ed8e Kurt Hackel       2005-12-15  808  
> 	config_group_init(&o2nm_cluster_group.cs_subsys.su_group);
> e6bd07ae Joel Becker       2007-07-06 @809  
> 	mutex_init(&o2nm_cluster_group.cs_subsys.su_mutex);
> 0c83ed8e Kurt Hackel       2005-12-15  810  	ret = 
> configfs_register_subsystem(&o2nm_cluster_group.cs_subsys);
> 0c83ed8e Kurt Hackel       2005-12-15  811  	if (ret) {
> 0c83ed8e Kurt Hackel       2005-12-15  812  		printk(KERN_ERR "nodemanager: 
> Registration returned %d\n", ret);
> 0c83ed8e Kurt Hackel       2005-12-15  813  		goto out_callbacks;
> 0c83ed8e Kurt Hackel       2005-12-15  814  	}
> 0c83ed8e Kurt Hackel       2005-12-15  815  
> 0c83ed8e Kurt Hackel       2005-12-15  816  	ret = o2cb_sys_init();
> 0c83ed8e Kurt Hackel       2005-12-15  817  	if (!ret)
> 0c83ed8e Kurt Hackel       2005-12-15  818  		goto out;
> 0c83ed8e Kurt Hackel       2005-12-15  819  
> 0c83ed8e Kurt Hackel       2005-12-15  820  
> 	configfs_unregister_subsystem(&o2nm_cluster_group.cs_subsys);
> 0c83ed8e Kurt Hackel       2005-12-15  821  out_callbacks:
> 0c83ed8e Kurt Hackel       2005-12-15  822  	o2net_unregister_hb_callbacks();
> 895928b8 Jeff Mahoney      2006-02-21  823  out_o2net:
> 895928b8 Jeff Mahoney      2006-02-21  824  	o2net_exit();
> 87d3d3f3 Sunil Mushran     2008-12-17  825  out_o2hb:
> 87d3d3f3 Sunil Mushran     2008-12-17  826  	o2hb_exit();
> 0c83ed8e Kurt Hackel       2005-12-15  827  out:
> 0c83ed8e Kurt Hackel       2005-12-15  828  	return ret;
> 0c83ed8e Kurt Hackel       2005-12-15  829  }
> 0c83ed8e Kurt Hackel       2005-12-15  830  
> 
> :::::: The code at line 809 was first introduced by commit
> :::::: e6bd07aee739566803425acdbf5cdb29919164e1 configfs: Convert subsystem 
> semaphore to mutex
> 
> :::::: TO: Joel Becker <joel.becker@oracle.com>
> :::::: CC: Mark Fasheh <mark.fasheh@oracle.com>
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://urldefense.proofpoint.com/v2/url?u=https-3A__lists.01.org_pipermail_k 
> build-2Dall&d=DwIBAg&c=RoP1YumCXCgaWHvlZYR8PQcxBKCX5YTpkKY057SbK10&r=f4ohdmGrYxZe
> jY77yzx3eNgTHb1ZAfZytktjHqNVzc8&m=8Ca3nktkbfrjbR5Spv4mvmdj2s377WohnG6h6z1WB7E&s
> =nLlW0xEmimMcnOene83E4zhz60ab1-1iXKtP_w_e8cQ&e=                    Intel 
> Corporation

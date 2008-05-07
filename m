From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 7 May 2008 11:11:16 -0700
Subject: [Ocfs2-devel] [RFC][PATCH] Configfs: Make nested default groups
	lockdep-safe.
In-Reply-To: <4821B869.7060906@kerlabs.com>
References: <4821B869.7060906@kerlabs.com>
Message-ID: <20080507181115.GB25992@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, May 07, 2008 at 04:10:49PM +0200, Louis Rilling wrote:
> The enclosed patch fixes lockdep issues with nested default groups in
> configfs. Please CC me in reply since I am not an ocfs2-devel subscriber.

	So we do need some sort of varied nesting - I was wondering
about that.  The last set of lockdep changes for configfs silenced all
warning reports I'd heard of, but I was unsure if they were the end of
it.
	This definitely uglifies the code - depth is passed all over the
place.  I think we're OK with the 6 levels of default groups.  Maybe we
want to always pass the field as "lockdep_depth", so we know what it's
talking about.  In the end, I think annotation is better than turning
off lockdep - I'm pretty certain the locking is right, but who knows
what we might break in the future :-)  I'd just like to see it less
intrusive than this.

Joel

> 
> -- 
> Dr Louis Rilling			Kerlabs
> Skype: louis.rilling			Batiment Germanium
> Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
> http://www.kerlabs.com/			35700 Rennes

> Subject: Make nested default groups lockdep-safe.
> 
> Current lockdep annotations for inode mutexes in configfs are lockdep-safe
> provided that:
> 1/ config_groups have at most one level of default groups (see
>    configfs_attach_group()),
> 2/ config_groups having default groups are never removed (see
>    configfs_detach_prep()).
> 
> This proof-of-concept patch adds lockdep annotations to make all kinds of
> default groups nesting lockdep-safe against creation and removal.
> For creation, the idea is to increment the lockdep sub-class at each level of
> nesting in configfs_attach_group() and configfs_create_file().
> For removal, the idea is to increment the lockdep sub-class at each lock of a
> default group's inode mutex in configfs_detach_prep().
> 
> This patch was tested on Linux 2.6.20 and ported (untested) to latest Linux git
> ( c0a18111e571138747a98af18b3a2124df56a0d1 ).
> 
> Unfortunately, this patch brings ugly changes to the internal configfs API,
> with a forced depth argument independently from LOCKDEP being activated or
> not, and only works with nesting depth < (MAX_LOCKDEP_SUBCLASSES -
> I_MUTEX_CHILD) (=6), and at most (MAX_LOCKDEP_SUBCLASSES - I_MUTEX_CHILD - 1
> (=5)) default groups (the whole tree) under created config_groups. For higher
> levels of nesting/numbers of default groups, lockdep issues a warning and turns
> itself off.
> 
> The other way to fix these lockdep issues could be to simply turn lockdep off
> while attaching a config_group (in configfs_register_subsystem() and in
> configfs_rmdir()), and while calling configfs_detatch_prep() and
> configfs_detach_group()/configfs_detach_rollback() (in
> configfs_unregister_subsystem() and configfs_rmdir()).
> 
> Signed-off-by: Louis Rilling <Louis.Rilling@kerlabs.com>
> ---
>  fs/configfs/configfs_internal.h |    4 +--
>  fs/configfs/dir.c               |   52 +++++++++++++++++++++++-----------------
>  fs/configfs/file.c              |    8 +++---
>  3 files changed, 37 insertions(+), 27 deletions(-)
> 
> 
> 
> Index: b/fs/configfs/configfs_internal.h
> ===================================================================
> --- a/fs/configfs/configfs_internal.h	2008-05-07 15:00:16.000000000 +0200
> +++ b/fs/configfs/configfs_internal.h	2008-05-07 15:19:35.000000000 +0200
> @@ -59,11 +59,11 @@ extern int configfs_create(struct dentry
>  extern int configfs_inode_init(void);
>  extern void configfs_inode_exit(void);
>  
> -extern int configfs_create_file(struct config_item *, const struct configfs_attribute *);
> +extern int configfs_create_file(struct config_item *, const struct configfs_attribute *, int);
>  extern int configfs_make_dirent(struct configfs_dirent *,
>  				struct dentry *, void *, umode_t, int);
>  
> -extern int configfs_add_file(struct dentry *, const struct configfs_attribute *, int);
> +extern int configfs_add_file(struct dentry *, const struct configfs_attribute *, int, int);
>  extern void configfs_hash_and_remove(struct dentry * dir, const char * name);
>  
>  extern const unsigned char * configfs_get_name(struct configfs_dirent *sd);
> Index: b/fs/configfs/dir.c
> ===================================================================
> --- a/fs/configfs/dir.c	2008-05-07 15:00:16.000000000 +0200
> +++ b/fs/configfs/dir.c	2008-05-07 15:30:23.000000000 +0200
> @@ -337,7 +337,7 @@ static struct dentry * configfs_lookup(s
>   * i_mutex.  If there is an error, the caller will clean up the i_mutex
>   * holders via configfs_detach_rollback().
>   */
> -static int configfs_detach_prep(struct dentry *dentry)
> +static int configfs_detach_prep(struct dentry *dentry, int *depth)
>  {
>  	struct configfs_dirent *parent_sd = dentry->d_fsdata;
>  	struct configfs_dirent *sd;
> @@ -352,7 +352,9 @@ static int configfs_detach_prep(struct d
>  		if (sd->s_type & CONFIGFS_NOT_PINNED)
>  			continue;
>  		if (sd->s_type & CONFIGFS_USET_DEFAULT) {
> -			mutex_lock(&sd->s_dentry->d_inode->i_mutex);
> +			mutex_lock_nested(&sd->s_dentry->d_inode->i_mutex,
> +					  I_MUTEX_CHILD + (*depth)++);
> +
>  			/* Mark that we've taken i_mutex */
>  			sd->s_type |= CONFIGFS_USET_DROPPING;
>  
> @@ -360,7 +362,8 @@ static int configfs_detach_prep(struct d
>  			 * Yup, recursive.  If there's a problem, blame
>  			 * deep nesting of default_groups
>  			 */
> -			ret = configfs_detach_prep(sd->s_dentry);
> +			ret = configfs_detach_prep(sd->s_dentry, depth);
> +
>  			if (!ret)
>  				continue;
>  		} else
> @@ -421,7 +424,7 @@ static void detach_attrs(struct config_i
>  	dput(dentry);
>  }
>  
> -static int populate_attrs(struct config_item *item)
> +static int populate_attrs(struct config_item *item, int depth)
>  {
>  	struct config_item_type *t = item->ci_type;
>  	struct configfs_attribute *attr;
> @@ -432,7 +435,7 @@ static int populate_attrs(struct config_
>  		return -EINVAL;
>  	if (t->ct_attrs) {
>  		for (i = 0; (attr = t->ct_attrs[i]) != NULL; i++) {
> -			if ((error = configfs_create_file(item, attr)))
> +			if ((error = configfs_create_file(item, attr, depth)))
>  				break;
>  		}
>  	}
> @@ -445,7 +448,8 @@ static int populate_attrs(struct config_
>  
>  static int configfs_attach_group(struct config_item *parent_item,
>  				 struct config_item *item,
> -				 struct dentry *dentry);
> +				 struct dentry *dentry,
> +				 int depth);
>  static void configfs_detach_group(struct config_item *item);
>  
>  static void detach_groups(struct config_group *group)
> @@ -496,7 +500,8 @@ static void detach_groups(struct config_
>   * try using vfs_mkdir.  Just a thought.
>   */
>  static int create_default_group(struct config_group *parent_group,
> -				struct config_group *group)
> +				struct config_group *group,
> +				int depth)
>  {
>  	int ret;
>  	struct qstr name;
> @@ -516,7 +521,7 @@ static int create_default_group(struct c
>  		d_add(child, NULL);
>  
>  		ret = configfs_attach_group(&parent_group->cg_item,
> -					    &group->cg_item, child);
> +					    &group->cg_item, child, depth + 1);
>  		if (!ret) {
>  			sd = child->d_fsdata;
>  			sd->s_type |= CONFIGFS_USET_DEFAULT;
> @@ -529,7 +534,7 @@ static int create_default_group(struct c
>  	return ret;
>  }
>  
> -static int populate_groups(struct config_group *group)
> +static int populate_groups(struct config_group *group, int depth)
>  {
>  	struct config_group *new_group;
>  	struct dentry *dentry = group->cg_item.ci_dentry;
> @@ -546,12 +551,12 @@ static int populate_groups(struct config
>  		 * That said, taking our i_mutex is closer to mkdir
>  		 * emulation, and shouldn't hurt.
>  		 */
> -		mutex_lock_nested(&dentry->d_inode->i_mutex, I_MUTEX_CHILD);
> +		mutex_lock_nested(&dentry->d_inode->i_mutex, I_MUTEX_CHILD + depth);
>  
>  		for (i = 0; group->default_groups[i]; i++) {
>  			new_group = group->default_groups[i];
>  
> -			ret = create_default_group(group, new_group);
> +			ret = create_default_group(group, new_group, depth);
>  			if (ret)
>  				break;
>  		}
> @@ -668,13 +673,14 @@ static void link_group(struct config_gro
>   */
>  static int configfs_attach_item(struct config_item *parent_item,
>  				struct config_item *item,
> -				struct dentry *dentry)
> +				struct dentry *dentry,
> +				int depth)
>  {
>  	int ret;
>  
>  	ret = configfs_create_dir(item, dentry);
>  	if (!ret) {
> -		ret = populate_attrs(item);
> +		ret = populate_attrs(item, depth);
>  		if (ret) {
>  			configfs_remove_dir(item);
>  			d_delete(dentry);
> @@ -692,17 +698,18 @@ static void configfs_detach_item(struct 
>  
>  static int configfs_attach_group(struct config_item *parent_item,
>  				 struct config_item *item,
> -				 struct dentry *dentry)
> +				 struct dentry *dentry,
> +				 int depth)
>  {
>  	int ret;
>  	struct configfs_dirent *sd;
>  
> -	ret = configfs_attach_item(parent_item, item, dentry);
> +	ret = configfs_attach_item(parent_item, item, dentry, depth);
>  	if (!ret) {
>  		sd = dentry->d_fsdata;
>  		sd->s_type |= CONFIGFS_USET_DIR;
>  
> -		ret = populate_groups(to_config_group(item));
> +		ret = populate_groups(to_config_group(item), depth);
>  		if (ret) {
>  			configfs_detach_item(item);
>  			d_delete(dentry);
> @@ -1094,9 +1101,9 @@ static int configfs_mkdir(struct inode *
>  	module_got = 1;
>  
>  	if (group)
> -		ret = configfs_attach_group(parent_item, item, dentry);
> +		ret = configfs_attach_group(parent_item, item, dentry, 0);
>  	else
> -		ret = configfs_attach_item(parent_item, item, dentry);
> +		ret = configfs_attach_item(parent_item, item, dentry, 0);
>  
>  out_unlink:
>  	if (ret) {
> @@ -1136,6 +1143,7 @@ static int configfs_rmdir(struct inode *
>  	struct configfs_dirent *sd;
>  	struct module *owner = NULL;
>  	int ret;
> +	int depth = 1;
>  
>  	if (dentry->d_parent == configfs_sb->s_root)
>  		return -EPERM;
> @@ -1161,7 +1169,7 @@ static int configfs_rmdir(struct inode *
>  		return -EINVAL;
>  	}
>  
> -	ret = configfs_detach_prep(dentry);
> +	ret = configfs_detach_prep(dentry, &depth);
>  	if (ret) {
>  		configfs_detach_rollback(dentry);
>  		config_item_put(parent_item);
> @@ -1418,7 +1426,8 @@ int configfs_register_subsystem(struct c
>  		d_add(dentry, NULL);
>  
>  		err = configfs_attach_group(sd->s_element, &group->cg_item,
> -					    dentry);
> +					    dentry,
> +					    0);
>  		if (err) {
>  			d_delete(dentry);
>  			dput(dentry);
> @@ -1439,6 +1448,7 @@ void configfs_unregister_subsystem(struc
>  {
>  	struct config_group *group = &subsys->su_group;
>  	struct dentry *dentry = group->cg_item.ci_dentry;
> +	int depth = 1;
>  
>  	if (dentry->d_parent != configfs_sb->s_root) {
>  		printk(KERN_ERR "configfs: Tried to unregister non-subsystem!\n");
> @@ -1448,7 +1458,7 @@ void configfs_unregister_subsystem(struc
>  	mutex_lock_nested(&configfs_sb->s_root->d_inode->i_mutex,
>  			  I_MUTEX_PARENT);
>  	mutex_lock_nested(&dentry->d_inode->i_mutex, I_MUTEX_CHILD);
> -	if (configfs_detach_prep(dentry)) {
> +	if (configfs_detach_prep(dentry, &depth)) {
>  		printk(KERN_ERR "configfs: Tried to unregister non-empty subsystem!\n");
>  	}
>  	configfs_detach_group(&group->cg_item);
> Index: b/fs/configfs/file.c
> ===================================================================
> --- a/fs/configfs/file.c	2008-05-07 15:00:16.000000000 +0200
> +++ b/fs/configfs/file.c	2008-05-07 15:19:35.000000000 +0200
> @@ -314,13 +314,13 @@ const struct file_operations configfs_fi
>  };
>  
>  
> -int configfs_add_file(struct dentry * dir, const struct configfs_attribute * attr, int type)
> +int configfs_add_file(struct dentry * dir, const struct configfs_attribute * attr, int type, int depth)
>  {
>  	struct configfs_dirent * parent_sd = dir->d_fsdata;
>  	umode_t mode = (attr->ca_mode & S_IALLUGO) | S_IFREG;
>  	int error = 0;
>  
> -	mutex_lock_nested(&dir->d_inode->i_mutex, I_MUTEX_NORMAL);
> +	mutex_lock_nested(&dir->d_inode->i_mutex, I_MUTEX_CHILD + depth);
>  	error = configfs_make_dirent(parent_sd, NULL, (void *) attr, mode, type);
>  	mutex_unlock(&dir->d_inode->i_mutex);
>  
> @@ -334,11 +334,11 @@ int configfs_add_file(struct dentry * di
>   *	@attr:	atrribute descriptor.
>   */
>  
> -int configfs_create_file(struct config_item * item, const struct configfs_attribute * attr)
> +int configfs_create_file(struct config_item * item, const struct configfs_attribute * attr, int depth)
>  {
>  	BUG_ON(!item || !item->ci_dentry || !attr);
>  
>  	return configfs_add_file(item->ci_dentry, attr,
> -				 CONFIGFS_ITEM_ATTR);
> +				 CONFIGFS_ITEM_ATTR, depth);
>  }
>  




-- 

"I inject pure kryptonite into my brain.
 It improves my kung fu, and it eases the pain."


Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127

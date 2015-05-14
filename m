From: Daniel Baluta <daniel.baluta@intel.com>
Date: Thu, 14 May 2015 13:49:43 +0300
Subject: [Ocfs2-devel] [PATCH v6 0/4] Add initial configfs support for
	IIO
In-Reply-To: <55538A93.5060004@kernel.org>
References: <CAEnQRZCMkXYv6XO2dG7MRP0XEQm4A5t2zPHWiSdeR=X-9C=CaQ@mail.gmail.com>
	<1431515641-19984-1-git-send-email-lars@metafoo.de>
	<55538A93.5060004@kernel.org>
Message-ID: <CAEnQRZBA4i6VucHTrhbA62np9dnrQQsq=N9NeWZu8NO=vii=DA@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jonathan Cameron <jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ocfs2-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org
Cc: Lars-Peter Clausen <lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org>, Daniel Baluta <daniel.baluta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Joel Becker <jlbec-aKy9MeLSZ9dg9hUCZPvPmw@public.gmane.org>, Hartmut Knaack <knaack.h-Mmb7MZpHnFY@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>, constantin.musca-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, marten-4zOpVvZifTgX8gGd4fc/mEEOCMrvLtNR@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org

On Wed, May 13, 2015 at 8:32 PM, Jonathan Cameron <jic23@kernel.org> wrote:
> On 13/05/15 12:14, Lars-Peter Clausen wrote:
>> Hi,
>>
>> I'd like to go back to the issue of having one folder per trigger type and
>> create triggers for a type in their respective folder.
>>
>> I'm not convinced that it is an intentional design restriction of configfs
>> that we can't do this, but rather a case of it not being implemented
>> because nobody needed it so far.
>>
>> See the proof-of-concept patch below. With this we get one sub-folder per
>> trigger type in /config/iio/triggers. It's not complete and doesn't do
>> proper locking yet and also unregister is not yet implemented but it shows
>> the concept how it could be done.
>>
>> I'm not saying that we definitely should go down that road, but it feels
>> cleaner to me. And another advantage is that it is discoverable which types
>> of triggers are available. Thoughts?
> Nice iff it doesn't break from the intent of configfs.  I know both Daniel and
> I looked for how to do this before taking the non directory based approach that
> the usbgadget driver took.
>
> What you loose is the possibility for auto probing modules based on trigger naming
> (equivalent of what the usbgadget driver does).  I undecided on whether we would
> want to do that anyway.

Ok, I will have a closer look.
>
> Joel, it's your filesystem.  Is doing this acceptable to you?

Adding fsdevel and ocfs2 people. Joel seems to be idle for an awful
long period of time.
I'm not sure if there is anyone maintaining configfs now :).

>>
>> - Lars
>>
>> ---
>>  drivers/iio/industrialio-configfs.c   | 43 ++++++++++++++++++-----------------
>>  drivers/iio/industrialio-sw-trigger.c | 12 ++++++----
>>  fs/configfs/dir.c                     | 28 +++++++++++++++++++++--
>>  include/linux/configfs.h              |  4 ++++
>>  include/linux/iio/sw_trigger.h        | 19 ++++++++++++++++
>>  5 files changed, 79 insertions(+), 27 deletions(-)
>>
>> diff --git a/drivers/iio/industrialio-configfs.c b/drivers/iio/industrialio-configfs.c
>> index daf318c..c1fa14f 100644
>> --- a/drivers/iio/industrialio-configfs.c
>> +++ b/drivers/iio/industrialio-configfs.c
>> @@ -22,27 +22,9 @@
>>  static struct config_group *trigger_make_group(struct config_group *group,
>>                                              const char *name)
>>  {
>> -     char *type_name;
>> -     char *trigger_name;
>> -     char buf[MAX_NAME_LEN];
>>       struct iio_sw_trigger *t;
>>
>> -     snprintf(buf, MAX_NAME_LEN, "%s", name);
>> -
>> -     /* group name should have the form <trigger-type>-<trigger-name> */
>> -     type_name = buf;
>> -     trigger_name = strchr(buf, '-');
>> -     if (!trigger_name) {
>> -             WARN_ONCE(1, "Unable to locate '-' in %s. Use <type>-<name>.\n",
>> -                       buf);
>> -             return ERR_PTR(-EINVAL);
>> -     }
>> -
>> -     /* replace - with \0, this nicely separates the two strings */
>> -     *trigger_name = '\0';
>> -     trigger_name++;
>> -
>> -     t = iio_sw_trigger_create(type_name, trigger_name);
>> +     t = iio_sw_trigger_create(group->cg_item.ci_name, name);
>>       if (IS_ERR(t))
>>               return ERR_CAST(t);
>>
>> @@ -60,13 +42,17 @@ static void trigger_drop_group(struct config_group *group,
>>       config_item_put(item);
>>  }
>>
>> -static struct configfs_group_operations triggers_ops = {
>> +static struct configfs_group_operations trigger_ops = {
>>       .make_group     = &trigger_make_group,
>>       .drop_item      = &trigger_drop_group,
>>  };
>>
>> +static struct config_item_type iio_trigger_group_type = {
>> +     .ct_group_ops = &trigger_ops,
>> +     .ct_owner       = THIS_MODULE,
>> +};
>> +
>>  static struct config_item_type iio_triggers_group_type = {
>> -     .ct_group_ops = &triggers_ops,
>>       .ct_owner       = THIS_MODULE,
>>  };
>>
>> @@ -97,6 +83,21 @@ static struct configfs_subsystem iio_configfs_subsys = {
>>       .su_mutex = __MUTEX_INITIALIZER(iio_configfs_subsys.su_mutex),
>>  };
>>
>> +int iio_sw_trigger_type_configs_register(struct iio_sw_trigger_type *tt)
>> +{
>> +     config_group_init_type_name(&tt->group, tt->name,
>> +             &iio_trigger_group_type);
>> +
>> +     return configfs_register_group(&iio_triggers_group, &tt->group);
>> +}
>> +EXPORT_SYMBOL_GPL(iio_sw_trigger_type_configs_register);
>> +
>> +void iio_sw_trigger_type_configs_unregister(struct iio_sw_trigger_type *tt)
>> +{
>> +     configfs_unregister_group(&tt->group);
>> +}
>> +EXPORT_SYMBOL_GPL(iio_sw_trigger_type_configs_unregister);
>> +
>>  static int __init iio_configfs_init(void)
>>  {
>>       config_group_init(&iio_triggers_group);
>> diff --git a/drivers/iio/industrialio-sw-trigger.c b/drivers/iio/industrialio-sw-trigger.c
>> index fa1ec51..312c33c 100644
>> --- a/drivers/iio/industrialio-sw-trigger.c
>> +++ b/drivers/iio/industrialio-sw-trigger.c
>> @@ -41,10 +41,12 @@ int iio_register_sw_trigger_type(struct iio_sw_trigger_type *t)
>>
>>       write_lock(&iio_trigger_types_lock);
>>       iter = __iio_find_sw_trigger_type(t->name, strlen(t->name));
>> -     if (iter)
>> +     if (iter) {
>>               ret = -EBUSY;
>> -     else
>> +     } else {
>>               list_add_tail(&t->list, &iio_trigger_types_list);
>> +             iio_sw_trigger_type_configs_register(t);
>> +     }
>>       write_unlock(&iio_trigger_types_lock);
>>
>>       return ret;
>> @@ -58,10 +60,12 @@ int iio_unregister_sw_trigger_type(struct iio_sw_trigger_type *t)
>>
>>       write_lock(&iio_trigger_types_lock);
>>       iter = __iio_find_sw_trigger_type(t->name, strlen(t->name));
>> -     if (!iter)
>> +     if (!iter) {
>>               ret = -EINVAL;
>> -     else
>> +     } else {
>> +             iio_sw_trigger_type_configs_unregister(t);
>>               list_del(&t->list);
>> +     }
>>       write_unlock(&iio_trigger_types_lock);
>>
>>       return ret;
>> diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
>> index c9c298b..0e2e0e6 100644
>> --- a/fs/configfs/dir.c
>> +++ b/fs/configfs/dir.c
>> @@ -659,7 +659,7 @@ static void detach_groups(struct config_group *group)
>>   * try using vfs_mkdir.  Just a thought.
>>   */
>>  static int create_default_group(struct config_group *parent_group,
>> -                             struct config_group *group)
>> +                             struct config_group *group, struct dentry **dentry)
>>  {
>>       int ret;
>>       struct configfs_dirent *sd;
>> @@ -679,6 +679,8 @@ static int create_default_group(struct config_group *parent_group,
>>               if (!ret) {
>>                       sd = child->d_fsdata;
>>                       sd->s_type |= CONFIGFS_USET_DEFAULT;
>> +                     if (dentry)
>> +                             *dentry = child;
>>               } else {
>>                       BUG_ON(child->d_inode);
>>                       d_drop(child);
>> @@ -699,7 +701,7 @@ static int populate_groups(struct config_group *group)
>>               for (i = 0; group->default_groups[i]; i++) {
>>                       new_group = group->default_groups[i];
>>
>> -                     ret = create_default_group(group, new_group);
>> +                     ret = create_default_group(group, new_group, NULL);
>>                       if (ret) {
>>                               detach_groups(group);
>>                               break;
>> @@ -1644,6 +1646,28 @@ const struct file_operations configfs_dir_operations = {
>>       .iterate        = configfs_readdir,
>>  };
>>
>> +int configfs_register_group(struct config_group *parent_group,
>> +     struct config_group *group)
>> +{
>> +     struct dentry *dentry;
>> +     int ret;
>> +
>> +     link_group(parent_group, group);
>> +
>> +     ret = create_default_group(parent_group, group, &dentry);
>> +     if (ret == 0)
>> +             configfs_dir_set_ready(dentry->d_fsdata);
>> +
>> +     return ret;
>> +}
>> +EXPORT_SYMBOL(configfs_register_group);
>> +
>> +void configfs_unregister_group(struct config_group *group)
>> +{
>> +     /* TODO */
>> +}
>> +EXPORT_SYMBOL(configfs_unregister_group);
>> +
>>  int configfs_register_subsystem(struct configfs_subsystem *subsys)
>>  {
>>       int err;
>> diff --git a/include/linux/configfs.h b/include/linux/configfs.h
>> index 34025df..a641bea 100644
>> --- a/include/linux/configfs.h
>> +++ b/include/linux/configfs.h
>> @@ -252,6 +252,10 @@ static inline struct configfs_subsystem *to_configfs_subsystem(struct config_gro
>>  int configfs_register_subsystem(struct configfs_subsystem *subsys);
>>  void configfs_unregister_subsystem(struct configfs_subsystem *subsys);
>>
>> +int configfs_register_group(struct config_group *parent_group,
>> +     struct config_group *group);
>> +void configfs_unregister_group(struct config_group *group);
>> +
>>  /* These functions can sleep and can alloc with GFP_KERNEL */
>>  /* WARNING: These cannot be called underneath configfs callbacks!! */
>>  int configfs_depend_item(struct configfs_subsystem *subsys, struct config_item *target);
>> diff --git a/include/linux/iio/sw_trigger.h b/include/linux/iio/sw_trigger.h
>> index 87803c7..5551a11 100644
>> --- a/include/linux/iio/sw_trigger.h
>> +++ b/include/linux/iio/sw_trigger.h
>> @@ -27,6 +27,10 @@ struct iio_sw_trigger_type {
>>       struct module *owner;
>>       const struct iio_sw_trigger_ops *ops;
>>       struct list_head list;
>> +#ifdef CONFIG_CONFIGFS_FS
>> +     struct config_group group;
>> +#endif
>> +
>>  };
>>
>>  struct iio_sw_trigger {
>> @@ -60,6 +64,10 @@ struct iio_sw_trigger *iio_sw_trigger_create(const char *, const char *);
>>  void iio_sw_trigger_destroy(struct iio_sw_trigger *);
>>
>>  #ifdef CONFIG_CONFIGFS_FS
>> +
>> +int iio_sw_trigger_type_configs_register(struct iio_sw_trigger_type *tt);
>> +void iio_sw_trigger_type_configs_unregister(struct iio_sw_trigger_type *tt);
>> +
>>  static inline
>>  struct iio_sw_trigger *to_iio_sw_trigger(struct config_item *item)
>>  {
>> @@ -75,6 +83,17 @@ void iio_config_group_init_type_name(struct config_group *group,
>>       config_group_init_type_name(group, name, type);
>>  }
>>  #else
>> +static inline int iio_sw_trigger_type_configs_register(
>> +     struct iio_sw_trigger_type *tt)
>> +{
>> +     return 0;
>> +}
>> +
>> +static inline void iio_sw_trigger_type_configs_unregister(
>> +     struct iio_sw_trigger_type *tt)
>> +{
>> +}
>> +
>>  static inline
>>  void iio_config_group_init_type_name(struct config_group *group,
>>                                    const char *name,
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo at vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

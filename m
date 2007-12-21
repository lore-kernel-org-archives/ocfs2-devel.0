From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri Dec 21 15:10:33 2007
Subject: [Ocfs2-devel] [PATCH 17/30] ocfs2: Handle the removal of
	struct subsystem
In-Reply-To: <1198193387-16606-16-git-send-email-sunil.mushran@oracle.com>
References: <1198193387-16606-1-git-send-email-sunil.mushran@oracle.com>
	<1198193387-16606-16-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20071221230929.GA15533@tasint.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Dec 20, 2007 at 03:29:34PM -0800, Sunil Mushran wrote:
> Commit 823bccfc4002296ba88c3ad0f049e1abd8108d30 in mainline removes struct
> subsystem from kobject.h. This patch allows one to build ocfs2 with kernels
> having/not having this change.

	A subsystem is just a {kset, ...}, so the pointers are actually
still equal.  I wouldn't introduce "struct kapi_kset".  We don't need
it.  You can just pass the kset on to mlog_sys_init().  See below.

>  
> -int mlog_sys_init(struct kset *o2cb_subsys)

Just keep this as struct kset...

> +int mlog_sys_init(struct kapi_kset *o2cb_subsys)
>  {
>  	int i = 0;
>  
> diff --git a/fs/ocfs2/cluster/masklog.h b/fs/ocfs2/cluster/masklog.h
> index 75cd877..2b78a1b 100644
> --- a/fs/ocfs2/cluster/masklog.h
> +++ b/fs/ocfs2/cluster/masklog.h
> @@ -278,7 +278,7 @@ extern struct mlog_bits mlog_and_bits, mlog_not_bits;
>  
>  #include <linux/kobject.h>
>  #include <linux/sysfs.h>
> -int mlog_sys_init(struct kset *o2cb_subsys);

Same here.  The better way is to introduce "kapi_subsystem_kset()":

+#ifdef STRUCT_SUBSYSTEM_DEFINED
+# define kapi_subsystem_kset(_sub) &((_sub)->kset)
+#else
+# define kapi_subsystem_kset(_sub) (_sub)
+#endif

Then you can call "int mlog_sys_init(struct kset *kset)" like so:

  mlog_sys_init(kapi_subsystem_kset(&o2cb_subsys));

> @@ -111,7 +111,7 @@ int o2cb_sys_init(void)
>  {
>  	int ret;
>  
> -	o2cb_subsys.kobj.ktype = &o2cb_subsys_type;
> +	o2cb_subsys.kapi_kobj.ktype = &o2cb_subsys_type;
>  	ret = subsystem_register(&o2cb_subsys);

becomes:

  kapi_subsystem_kset(&o2cb_subsys)->kobj.ktype = &o2cb_subsys_type;
  ret = subsystem_register(&o2cb_subsys);

and this: 

>  o2cb_show(struct kobject * kobj, struct attribute * attr, char * buffer)
>  {
>  	struct o2cb_attribute *o2cb_attr = to_o2cb_attr(attr);
> -	struct kset *sbs = to_kset(kobj);
> +	struct kapi_kset *sbs = to_kapi_kset(kobj);
>  
>  	BUG_ON(sbs != &o2cb_subsys);

becomes this:

  o2cb_show(struct kobject * kobj, struct attribute * attr, char * buffer)
  {
  	struct o2cb_attribute *o2cb_attr = to_o2cb_attr(attr);
	struct kset *sbs = to_kset(kobj);

        BUG_ON(sbs != &o2cb_subsys);

because the kset and subsystem pointers are identical.  If gcc warns
about the types, you can say:

        BUG_ON(sbs != kapi_subsystem_kset(&o2cb_subsys));

instead.  Thoughts?

Joel

-- 

"And yet I fight,
 And yet I fight this battle all alone.
 No one to cry to;
 No place to call home."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127

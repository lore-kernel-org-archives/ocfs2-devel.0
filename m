From: Joel Becker <jlbec@evilplan.org>
Date: Fri, 13 May 2011 11:06:12 -0700
Subject: [Ocfs2-devel] [Patch] ocfs2: remove the /sys/o2cb symlink
In-Reply-To: <1304256856-4744-1-git-send-email-amwang@redhat.com>
References: <1304256856-4744-1-git-send-email-amwang@redhat.com>
Message-ID: <20110513180607.GA2349@noexit.corp.google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Amerigo Wang <amwang@redhat.com>
Cc: ocfs2-devel@oss.oracle.com, Randy Dunlap <rdunlap@xenotime.net>, Mark Fasheh <mfasheh@suse.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Sun, May 01, 2011 at 09:34:16PM +0800, Amerigo Wang wrote:
> It is obsoleted since Dec 2005.

	Actually, we moved it in 2008.  Sunil, Mark, do we have new
enough tools everywhere?  Looks like ocfs2-tools 1.4 has it.  I'm going
to take this unless you object.

Joel

> 
> Signed-off-by: WANG Cong <amwang@redhat.com>
> 
> ---
>  Documentation/ABI/obsolete/o2cb            |   11 -----------
>  Documentation/ABI/removed/o2cb             |   10 ++++++++++
>  Documentation/feature-removal-schedule.txt |   10 ----------
>  fs/ocfs2/cluster/sys.c                     |    9 ---------
>  4 files changed, 10 insertions(+), 30 deletions(-)
> ---
> diff --git a/Documentation/ABI/obsolete/o2cb b/Documentation/ABI/obsolete/o2cb
> deleted file mode 100644
> index 9c49d8e..0000000
> --- a/Documentation/ABI/obsolete/o2cb
> +++ /dev/null
> @@ -1,11 +0,0 @@
> -What:		/sys/o2cb symlink
> -Date:		Dec 2005
> -KernelVersion:	2.6.16
> -Contact:	ocfs2-devel at oss.oracle.com
> -Description:	This is a symlink: /sys/o2cb to /sys/fs/o2cb. The symlink will
> -		be removed when new versions of ocfs2-tools which know to look
> -		in /sys/fs/o2cb are sufficiently prevalent. Don't code new
> -		software to look here, it should try /sys/fs/o2cb instead.
> -		See Documentation/ABI/stable/o2cb for more information on usage.
> -Users:		ocfs2-tools. It's sufficient to mail proposed changes to
> -		ocfs2-devel at oss.oracle.com.
> diff --git a/Documentation/ABI/removed/o2cb b/Documentation/ABI/removed/o2cb
> new file mode 100644
> index 0000000..7f5daa4
> --- /dev/null
> +++ b/Documentation/ABI/removed/o2cb
> @@ -0,0 +1,10 @@
> +What:		/sys/o2cb symlink
> +Date:		May 2011
> +KernelVersion:	2.6.40
> +Contact:	ocfs2-devel at oss.oracle.com
> +Description:	This is a symlink: /sys/o2cb to /sys/fs/o2cb. The symlink is
> +		removed when new versions of ocfs2-tools which know to look
> +		in /sys/fs/o2cb are sufficiently prevalent. Don't code new
> +		software to look here, it should try /sys/fs/o2cb instead.
> +Users:		ocfs2-tools. It's sufficient to mail proposed changes to
> +		ocfs2-devel at oss.oracle.com.
> diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
> index 492e81d..5f3561e 100644
> --- a/Documentation/feature-removal-schedule.txt
> +++ b/Documentation/feature-removal-schedule.txt
> @@ -273,16 +273,6 @@ Who:	Michael Buesch <mb@bu3sch.de>
>  
>  ---------------------------
>  
> -What:	/sys/o2cb symlink
> -When:	January 2010
> -Why:	/sys/fs/o2cb is the proper location for this information - /sys/o2cb
> -	exists as a symlink for backwards compatibility for old versions of
> -	ocfs2-tools. 2 years should be sufficient time to phase in new versions
> -	which know to look in /sys/fs/o2cb.
> -Who:	ocfs2-devel at oss.oracle.com
> -
> ----------------------------
> -
>  What:	Ability for non root users to shm_get hugetlb pages based on mlock
>  	resource limits
>  When:	2.6.31
> diff --git a/fs/ocfs2/cluster/sys.c b/fs/ocfs2/cluster/sys.c
> index bc702da..a4b0773 100644
> --- a/fs/ocfs2/cluster/sys.c
> +++ b/fs/ocfs2/cluster/sys.c
> @@ -57,7 +57,6 @@ static struct kset *o2cb_kset;
>  void o2cb_sys_shutdown(void)
>  {
>  	mlog_sys_shutdown();
> -	sysfs_remove_link(NULL, "o2cb");
>  	kset_unregister(o2cb_kset);
>  }
>  
> @@ -69,14 +68,6 @@ int o2cb_sys_init(void)
>  	if (!o2cb_kset)
>  		return -ENOMEM;
>  
> -	/*
> -	 * Create this symlink for backwards compatibility with old
> -	 * versions of ocfs2-tools which look for things in /sys/o2cb.
> -	 */
> -	ret = sysfs_create_link(NULL, &o2cb_kset->kobj, "o2cb");
> -	if (ret)
> -		goto error;
> -
>  	ret = sysfs_create_group(&o2cb_kset->kobj, &o2cb_attr_group);
>  	if (ret)
>  		goto error;

-- 

"We will have to repent in this generation not merely for the
 vitriolic words and actions of the bad people, but for the 
 appalling silence of the good people."
	- Rev. Dr. Martin Luther King, Jr.

			http://www.jlbec.org/
			jlbec at evilplan.org

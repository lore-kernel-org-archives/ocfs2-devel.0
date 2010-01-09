From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 8 Jan 2010 16:08:53 -0800
Subject: [Ocfs2-devel] +
 sysctl-use-rcu-protected-sysctl-for-ocfs-group-add-helper.patch added to
 -mm tree
In-Reply-To: <201001082354.o08NsLGV021886@imap1.linux-foundation.org>
References: <201001082354.o08NsLGV021886@imap1.linux-foundation.org>
Message-ID: <20100109000853.GC24532@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Jan 08, 2010 at 03:54:20PM -0800, akpm at linux-foundation.org wrote:
> 
> The patch titled
>      sysctl: use RCU protected sysctl for ocfs group add helper
> has been added to the -mm tree.  Its filename is
>      sysctl-use-rcu-protected-sysctl-for-ocfs-group-add-helper.patch

NAK until I can figure out how to make it always succeed.  We can't have
umount "succeed" like this.

Maybe the solution is GFP_ATOMIC.  Maybe the solution is to lock on the
setting end.  But this isn't it.

Joel

[Not eliding the patch so ocfs2-devel can see it]

> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
> out what to do about this
> 
> The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
> 
> ------------------------------------------------------
> Subject: sysctl: use RCU protected sysctl for ocfs group add helper
> From: Andi Kleen <andi@firstfloor.org>
> 
> This avoids races with unlocked sysctl()
> 
> Also saves ~220 bytes in the data segment.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
> Cc: Russell King <rmk+lkml@arm.linux.org.uk>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: Joel Becker <Joel.Becker@oracle.com>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  fs/ocfs2/stackglue.c |   17 +++++++++++++----
>  1 file changed, 13 insertions(+), 4 deletions(-)
> 
> diff -puN fs/ocfs2/stackglue.c~sysctl-use-rcu-protected-sysctl-for-ocfs-group-add-helper fs/ocfs2/stackglue.c
> --- a/fs/ocfs2/stackglue.c~sysctl-use-rcu-protected-sysctl-for-ocfs-group-add-helper
> +++ a/fs/ocfs2/stackglue.c
> @@ -27,6 +27,7 @@
>  #include <linux/kobject.h>
>  #include <linux/sysfs.h>
>  #include <linux/sysctl.h>
> +#include <linux/rcustring.h>
>  
>  #include "ocfs2_fs.h"
>  
> @@ -40,7 +41,7 @@ static struct ocfs2_locking_protocol *lp
>  static DEFINE_SPINLOCK(ocfs2_stack_lock);
>  static LIST_HEAD(ocfs2_stack_list);
>  static char cluster_stack_name[OCFS2_STACK_LABEL_LEN + 1];
> -static char ocfs2_hb_ctl_path[OCFS2_MAX_HB_CTL_PATH] = "/sbin/ocfs2_hb_ctl";
> +static char *ocfs2_hb_ctl_path = "/sbin/ocfs2_hb_ctl";
>  
>  /*
>   * The stack currently in use.  If not null, active_stack->sp_count > 0,
> @@ -395,8 +396,15 @@ static void ocfs2_leave_group(const char
>  {
>  	int ret;
>  	char *argv[5], *envp[3];
> +	char *helper;
>  
> -	argv[0] = ocfs2_hb_ctl_path;
> +	helper = access_rcu_string(&ocfs2_hb_ctl_path, OCFS2_MAX_HB_CTL_PATH, GFP_KERNEL);
> +	if (!helper) {
> +		printk(KERN_ERR "ocfs2_leave_group: no memory\n");
> +		return;
> +	}
> +
> +	argv[0] = helper;
>  	argv[1] = "-K";
>  	argv[2] = "-u";
>  	argv[3] = (char *)group;
> @@ -414,6 +422,7 @@ static void ocfs2_leave_group(const char
>  		       "\"%s %s %s %s\"\n",
>  		       ret, argv[0], argv[1], argv[2], argv[3]);
>  	}
> +	kfree(helper);
>  }
>  
>  /*
> @@ -621,10 +630,10 @@ error:
>  static ctl_table ocfs2_nm_table[] = {
>  	{
>  		.procname	= "hb_ctl_path",
> -		.data		= ocfs2_hb_ctl_path,
> +		.data		= &ocfs2_hb_ctl_path,
>  		.maxlen		= OCFS2_MAX_HB_CTL_PATH,
>  		.mode		= 0644,
> -		.proc_handler	= proc_dostring,
> +		.proc_handler	= proc_rcu_string,
>  	},
>  	{ }
>  };
> _
> 
> Patches currently in -mm which might be from andi at firstfloor.org are
> 
> kernel-signalc-fix-kernel-information-leak-with-print-fatal-signals=1.patch
> proc-revert-procfs-provide-stack-information-for-threads.patch
> kfifo-use-void-pointers-for-user-buffers.patch
> kfifo-sanitize-_user-error-handling.patch
> kfifo-add-kfifo_out_peek.patch
> kfifo-add-kfifo_initialized.patch
> kfifo-document-everywhere-that-size-has-to-be-power-of-two.patch
> hardware-latency-detector-remove-default-m.patch
> kbuild-move-fno-dwarf2-cfi-asm-to-powerpc-only.patch
> mm-introduce-dump_page-and-print-symbolic-flag-names.patch
> coredump-unify-dump_seek-implementations-for-each-binfmt_c.patch
> coredump-move-dump_write-and-dump_seek-into-a-header-file.patch
> elf-coredump-replace-elf_core_extra_-macros-by-functions.patch
> elf-coredump-make-offset-calculation-process-and-writing-process-explicit.patch
> elf-coredump-add-extended-numbering-support.patch
> tracehooks-kill-some-pt_ptraced-checks.patch
> tracehooks-check-pt_ptraced-before-reporting-the-single-step.patch
> ptrace_signal-check-pt_ptraced-before-reporting-a-signal.patch
> export-__ptrace_detach-and-do_notify_parent_cldstop.patch
> reorder-the-code-in-kernel-ptracec.patch
> implement-utrace-ptrace.patch
> utrace-core.patch
> rcu-add-rcustring-adt-for-rcu-protected-strings.patch
> add-a-kernel_address-that-works-for-data-too.patch
> sysctl-add-proc_rcu_string-to-manage-sysctls-using-rcu-strings.patch
> sysctl-use-rcu-strings-for-core_pattern-sysctl.patch
> sysctl-add-call_usermodehelper_cleanup.patch
> sysctl-convert-modprobe_path-to-proc_rcu_string.patch
> sysctl-convert-poweroff_command-to-proc_rcu_string.patch
> sysctl-convert-hotplug-helper-string-to-proc_rcu_string.patch
> sysctl-use-rcu-protected-sysctl-for-ocfs-group-add-helper.patch
> 

-- 

"Born under a bad sign.
 I been down since I began to crawl.
 If it wasn't for bad luck,
 I wouldn't have no luck at all."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127

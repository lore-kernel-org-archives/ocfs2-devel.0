From: Sunil Mushran <Sunil.Mushran@oracle.com>
Date: Wed Mar 28 10:33:27 2007
Subject: [Ocfs2-devel] mount gnenerates an error : "Unable to
	access	cluster service while starting heartbeat"
In-Reply-To: <147a89290703281029q8818140kc7f1d872e9f3df61@mail.gmail.com>
References: <147a89290703280827w67339993y32557cfd8067733a@mail.gmail.com>	<460A968D.4030204@oracle.com>
	<147a89290703281029q8818140kc7f1d872e9f3df61@mail.gmail.com>
Message-ID: <460AA6E3.4000802@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

He meant... cat /etc/sysconfig/o2cb
If you are using novell's userspace hb, then it will be listed there.

Andy Johnson wrote:
> Hello,
> NO such thing as /sys/o2cb/heartbeat_mode !
> I tried :
>
>  /etc/init.d/o2cb load
> Loading module "configfs": OK
> Mounting configfs filesystem at /sys/kernel/config: OK
> Loading module "ocfs2_nodemanager": OK
> Loading module "ocfs2_dlm": OK
> Loading module "ocfs2_dlmfs": OK
> Mounting ocfs2_dlmfs filesystem at /dlm: OK
>
>  :/root# ls /sys/o2cb
> interface_revision  logmask
> and
>
> ls  /sys/o2cb/logmask
> ls /sys/o2cb/logmask -al
> total 0
> drwxr-xr-x 2 root root    0 Mar 28 19:28 .
> drwxr-xr-x 3 root root    0 Mar 28 19:26 ..
> -rw-r--r-- 1 root root 4096 Mar 28 19:28 AIO
> -rw-r--r-- 1 root root 4096 Mar 28 19:28 BH_IO
> -rw-r--r-- 1 root root 4096 Mar 28 19:28 CONN
> -rw-r--r-- 1 root root 4096 Mar 28 19:28 DCACHE
> -rw-r--r-- 1 root root 4096 Mar 28 19:28 DISK_ALLOC
> -rw-r--r-- 1 root root 4096 Mar 28 19:28 DLM
> -rw-r--r-- 1 root root 4096 Mar 28 19:28 DLM_DOMAIN
> -rw-r--r-- 1 root root 4096 Mar 28 19:28 DLMFS
> -rw-r--r-- 1 root root 4096 Mar 28 19:28 DLM_GLUE
> -rw-r--r-- 1 root root 4096 Mar 28 19:28 DLM_MASTER
> -rw-r--r-- 1 root root 4096 Mar 28 19:28 DLM_RECOVERY
> -rw-r--r-- 1 root root 4096 Mar 28 19:28 DLM_THREAD
> -rw-r--r-- 1 root root 4096 Mar 28 19:28 ENTRY
> -rw-r--r-- 1 root root 4096 Mar 28 19:28 ERROR
> -rw-r--r-- 1 root root 4096 Mar 28 19:28 EXIT
> -rw-r--r-- 1 root root 4096 Mar 28 19:28 EXPORT
> -rw-r--r-- 1 root root 4096 Mar 28 19:28 EXTENT_MAP
> -rw-r--r-- 1 root root 4096 Mar 28 19:28 FILE_IO
> -rw-r--r-- 1 root root 4096 Mar 28 19:28 HB_BIO
> -rw-r--r-- 1 root root 4096 Mar 28 19:28 HEARTBEAT
> -rw-r--r-- 1 root root 4096 Mar 28 19:28 INODE
> -rw-r--r-- 1 root root 4096 Mar 28 19:28 JOURNAL
> -rw-r--r-- 1 root root 4096 Mar 28 19:28 KTHREAD
> -rw-r--r-- 1 root root 4096 Mar 28 19:28 MSG
> -rw-r--r-- 1 root root 4096 Mar 28 19:28 NAMEI
> -rw-r--r-- 1 root root 4096 Mar 28 19:28 NOTICE
> -rw-r--r-- 1 root root 4096 Mar 28 19:28 QUORUM
> -rw-r--r-- 1 root root 4096 Mar 28 19:28 SOCKET
> -rw-r--r-- 1 root root 4096 Mar 28 19:28 SUPER
> -rw-r--r-- 1 root root 4096 Mar 28 19:28 TCP
> -rw-r--r-- 1 root root 4096 Mar 28 19:28 UPTODATE
> -rw-r--r-- 1 root root 4096 Mar 28 19:28 VOTE
>
> and
>
> cat /sys/o2cb/logmask/HEARTBEAT
> off
> Regards,
> Andy
>
>
>
> On 3/28/07, *Srinivas Eeda* < srinivas.eeda@oracle.com 
> <mailto:srinivas.eeda@oracle.com>> wrote:
>
>     That might because you have configured user mode dlm. What does "|cat
>     /sys/o2cb/heartbeat_mode" show, "user"?. If so run, /etc/init.d/o2cb
>     configure and answer "n" for the following
>     ||Use user-space driven heartbeat? (y/n) [y] n
>
>     thanks,
>     --Srini
>     ||
>
>     |Andy Johnson wrote:
>     > Hello,
>     > I have ocfs2-tools-1.2.3. ( built from sources)
>     > I try:
>     >  mount /dev/vg1/cluster /mnt/ocfs2/
>     > and get:
>     > ocfs2_hb_ctl: Unable to access cluster service while starting
>     heartbeat
>     > mount.ocfs2: Error when attempting to run /sbin/ocfs2_hb_ctl:
>     > "Operation not permitted"
>     >
>     > What can be the cause of this error ? Any ideas?
>     >
>     > (I tried it after service heartbeat stop)
>     >
>     > Regards,
>     > Andy
>     >
>     ------------------------------------------------------------------------
>     >
>     > _______________________________________________
>     > Ocfs2-devel mailing list
>     > Ocfs2-devel@oss.oracle.com <mailto:Ocfs2-devel@oss.oracle.com>
>     > http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>
>
> ------------------------------------------------------------------------
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel

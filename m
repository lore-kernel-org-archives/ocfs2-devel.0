From: Sami <techker_s@yahoo.com>
Date: Wed Sep 15 20:38:14 2004
Subject: [Ocfs2-devel] Re: Ocfs2-devel Digest, Vol 9, Issue 4
In-Reply-To: <200409141700.i8EH0L4s014112@oss.oracle.com>
Message-ID: <20040916013810.73788.qmail@web61009.mail.yahoo.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I installed ocfs2 on Fedora Core 2. 
ocfstool does not get installed, should i log this as
a  bug ?


[root@saturn /]# uname -a
Linux saturn 2.6.5-1.358 #1 Sat May 8 09:04:50 EDT
2004 i686 i686 i386 GNU/Linux
[root@saturn /]#

[root@saturn /]# rpm -qa | grep -i ocfs
ocfs2-tools-0.99.0-1
ocfs2-2.4.21-EL-0.99.2-1
ocfs2-support-0.99.0-1


[root@saturn /]# which ocfstool
/usr/bin/which: no ocfstool in
(/usr/kerberos/sbin:/usr/kerberos/bin:/usr/local/
sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/X11R6/bin:/root/bin)
[root@saturn /]# which ocfs2tool
/usr/bin/which: no ocfs2tool in
(/usr/kerberos/sbin:/usr/kerberos/bin:/usr/local
/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/X11R6/bin:/root/bin)
[root@saturn /]#

[root@saturn /]# find . -name "*ocfs*"
./lib/modules/2.4.21-EL-ABI/ocfs2
./lib/modules/2.4.21-EL-ABI/ocfs2/ocfs2.o
./usr/local/src/ocfs2-support-0.99.0-1.i386.rpm
./usr/local/src/ocfs2-2.4.21-EL-0.99.2-1.i686.rpm
./usr/local/src/ocfs2-tools-0.99.0-1.i386.rpm
./usr/include/sys/procfs.h
./usr/src/linux-2.6.5-1.358/fs/reiserfs/procfs.c
./usr/src/linux-2.6.5-1.358/drivers/media/video/zoran_procfs.h
./usr/src/linux-2.6.5-1.358/drivers/media/video/zoran_procfs.c
./usr/src/linux-2.6.5-1.358/drivers/parport/procfs.c
./usr/src/linux-2.6.5-1.358/drivers/isdn/divert/divert_procfs.c
./usr/src/linux-2.6.5-1.358/arch/v850/kernel/procfs.c
./usr/src/linux-2.6.5-1.358/Documentation/DocBook/procfs_example.c
./usr/src/linux-2.6.5-1.358/Documentation/DocBook/procfs-guide.tmpl
./usr/share/man/man8/mkfs.ocfs2.8.gz
./usr/share/man/man8/debugfs.ocfs2.8.gz
./etc/rc.d/rc4.d/S24ocfs2
./etc/rc.d/rc5.d/S24ocfs2
./etc/rc.d/rc2.d/S24ocfs2
./etc/rc.d/init.d/ocfs2
./etc/rc.d/rc3.d/S24ocfs2
./sbin/ocfs_uid_gen2
./sbin/load_ocfs2
./sbin/debugfs.ocfs2
./sbin/mkfs.ocfs2
./sbin/mounted.ocfs2

> Message: 1
> Date: Mon, 13 Sep 2004 18:48:42 -0700
> From: Mark Fasheh <mark.fasheh@oracle.com>
> Subject: [Ocfs2-devel] OCFS2 Beta 6 Release
> To: ocfs2-users@oss.oracle.com,
> ocfs2-devel@oss.oracle.com
> Message-ID:
> <20040914014842.GA1820@ca-server1.us.oracle.com>
> Content-Type: text/plain; charset=us-ascii
> 
> http://oss.oracle.com/projects/ocfs2/
> 
> The OCFS2 team is pleased to announce our sixth beta
> release!
> 
> RPM packages can be found in the files section on
> the web site.
> 
> *** Please do not use Oracle support for OCFS2 Beta
> 6 bugs. Bugs should be
> eported using the bugzilla system on oss.oracle.com.
> 
> For more details, and instructions on how to install
> OCFS2 please visit the
> web page.
> 
> Thanks!
> The OCFS2 Team
> 
> 
> 
> ------------------------------
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel@oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
> 
> End of Ocfs2-devel Digest, Vol 9, Issue 4
> *****************************************
> 



		
__________________________________
Do you Yahoo!?
New and Improved Yahoo! Mail - Send 10MB messages!
http://promotions.yahoo.com/new_mail 

From: keyur patel <keyur.patel@oracle.com>
Date: Mon, 4 May 2009 13:20:05 -0400
Subject: [Ocfs2-devel] FW: Oracle 9204 installation on linux x86-64 on
 ocfs
In-Reply-To: <49FF1FD1.2050401@oracle.com>
Message-ID: <20090504132005000.00000004236@kpatel-us>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

No I didnt use that option. I put following entry into /etc/fstab and restart a server to mount file system on boot.



/dev/sdc        /u02    ocfs2   _netdev,defaults        0       0
/dev/sdd        /u03    ocfs2   _netdev,defaults        0       0
/dev/sde        /u04    ocfs2   _netdev,defaults        0       0
/dev/sdf        /u05    ocfs2   _netdev,defaults        0       0

While, mounting manualy, I use 

	mount -L "vote1" /u04/quorum

Also, someone would explain me what should be owner and permission on quorum file. I currently have following setting where orainventory is oracle software installer group.

drwxrwxr-x  2 root orainventory 4096 May  4 14:25 lost+found
-rwxrwxr-x  1 root orainventory    0 May  4 14:31 quorum.dbf
 
Thanks 

~ Keyur
-----Original Message-----
From: Srinivas Eeda [mailto:srinivas.eeda at oracle.com]
Sent: Monday, May 04, 2009 1:03 PM
To: keyur.patel at oracle.com
Cc: ocfs2-devel at oss.oracle.com; ocfs2-users at oss.oracle.com
Subject: Re: [Ocfs2-devel] FW: Oracle 9204 installation on linux x86-64
on ocfs


did you use "-o datavolume, nointr" options for mounting?

keyur patel wrote:
> Hello All,
>
> I have installed Oracle Cluster Manager on linux x86-64 nit. I am
> using ocfs file system for quorum file. But I am getting following
> error. Please see ocfs configureation below. I would appreciate, if
> someone could help me to understand if I am doing something wrong.
> Thanks in advance.
> --------------------------------------------------cm.log file
> ----------------------------
> oracm, version[ AMD64.9.2.0.4.0.00 ] started {Mon May  4 05:34:38 2009 }
> >TRACE:    Can't read registry value for HeartBeat, tid =
> main:182895169120 file = unixinc.c, line = 1077 {Mon May  4 05:34:38
> 2009 }
> >TRACE:    Can't read registry value for PollInterval, tid =
> main:182895169120 file = unixinc.c, line = 1077 {Mon May  4 05:34:38
> 2009 }
> >TRACE:    Can't read registry value for WatchdogTimerMargin, tid =
> main:182895169120 file = unixinc.c, line = 1077 {Mon May  4 05:34:38
> 2009 }
> >TRACE:    Can't read registry value for WatchdogSafetyMargin, tid =
> main:182895169120 file = unixinc.c, line = 1077 {Mon May  4 05:34:38
> 2009 }
> KernelModuleName is hangcheck-timer {Mon May  4 05:34:38 2009 }
> >TRACE:    Can't read registry value for ClientTimeout, tid =
> main:182895169120 file = unixinc.c, line = 1077 {Mon May  4 05:34:38
> 2009 }
> >TRACE:    InitNMInfo:  setting clientTimeout to 143s based on
> MissCount 215 and PollInterval 1000ms, tid = main:182895169120 file =
> nmconfig.c, line = 138 {Mon May  4 05:34:38 2009 }
> >TRACE:    InitClusterDb(): getservbyname on CMSrvr failed - 0 :
> assigning 9998, tid = main:182895169120 file = nmconfig.c, line = 208
> {Mon May  4 05:34:38 2009 }
> OemNodeConfig(): Network Address of node0: 1.1.1.1 (port 9998)
>  {Mon May  4 05:34:38 2009 }
> OemNodeConfig(): Network Address of node1: 1.1.1.2 (port 9998)
>  {Mon May  4 05:34:38 2009 }
> >TRACE:    OemCreateListenPort:  bound at 9998, tid =
> main:182895169120 file = oem.c, line = 858 {Mon May  4 05:34:38 2009 }
> >TRACE:    InitClusterDb():  found my node info at 1 name
> s602749nj3el19, priv s602749nj3el19priv, port 3623, tid =
> main:182895169120 file = nmconfig.c, line = 261 {Mon May  4 05:34:38
> 2009 }
> OemNodeConfig(): Network Address of node2: 1.1.1.3 (port 9998)
>  {Mon May  4 05:34:38 2009 }
> OemNodeConfig(): Network Address of node3: 1.1.1.4 (port 9998)
>  {Mon May  4 05:34:38 2009 }
> >TRACE:    InitClusterDb(): Local Node(1)
> NodeName[s602749nj3el19priv], tid = main:182895169120 file =
> nmconfig.c, line = 279 {Mon May  4 05:34:38 2009 }
> >TRACE:    InitClusterDb(): Cluster(Oracle) with (4) Defined Nodes,
> tid = main:182895169120 file = nmconfig.c, line = 282 {Mon May  4
> 05:34:38 2009 }
> >TRACE:    OEMInits(): CM Disk File (/u04/quorum/quorum.dbf), tid =
> main:182895169120 file = oem.c, line = 243 {Mon May  4 05:34:38 2009 }
> >ERROR:    OemInit2: Attempting to open the CMDiskFile for a
> multi-node RAC on a non-NFS, non-OCFS, or non-raw device cluster, tid
> = main:182895169120 file = oem.c, line = 482 {Mon May  4 05:34:38 2009 }
> >ERROR:    OemInit2: If the CMDiskFile is supposed to be an NFS or
> OCFS file, please make sure that the relevant shared file system is
> mounted properly, tid = main:182895169120 file = oem.c, line = 483
> {Mon May  4 05:34:38 2009 }
> >ERROR:    OemInit2: If the CMDiskFile is supposed to be a raw device,
> please make sure that it has been created properly, tid =
> main:182895169120 file = oem.c, line = 484 {Mon May  4 05:34:38 2009 }
> --- End Dump ---
> -------------------------------------------- OCFS setup
> -----------------------------
> [root at s602749nj3el19 bin]# mounted.ocfs2 -f
> Device                FS     Nodes
> /dev/sdc              ocfs2  s602749nj3el18, s602749nj3el19,
> s602749nj3el21, s602749nj3el20
> /dev/sdd              ocfs2  s602749nj3el18, s602749nj3el19,
> s602749nj3el21, s602749nj3el20
> /dev/sde              ocfs2  s602749nj3el18, s602749nj3el19,
> s602749nj3el21, s602749nj3el20
> /dev/sdf              ocfs2  s602749nj3el18, s602749nj3el19,
> s602749nj3el21, s602749nj3el20
> [root at s602749nj3el19 bin]# df -kh
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/mapper/VolGroup00-LogVol00
>                       2.0G  368M  1.6G  20% /
> /dev/sda1              61M   24M   35M  41% /boot
> /dev/mapper/VolGroup00-LogVol05
>                        19G   11G  7.6G  58% /data01
> none                  7.9G     0  7.9G   0% /dev/shm
> /dev/mapper/VolGroup00-LogVol04
>                       2.0G   53M  1.9G   3% /tmp
> /dev/mapper/VolGroup00-LogVol02
>                       3.0G  1.8G  1.1G  64% /usr
> /dev/mapper/VolGroup00-LogVol03
>                       2.0G   94M  1.8G   5% /var
> /dev/mapper/VolGroup01-u01
>                       148G   93M  141G   1% /u01
> /dev/sdc              600G  1.1G  599G   1% /u02
> /dev/sdd              300G  1.1G  299G   1% /u03
> /dev/sde              1.0G  274M  751M  27% /u04/quorum
> /dev/sdf              1.0G  262M  763M  26% /u05
> [root at s602749nj3el19 bin]# cd /u04/quorum/
> [root at s602749nj3el19 quorum]# ls -ltr
> total 8
> drwxrwxr-x  2 oracle orainventory 4096 May  1 21:43 lost+found
> drwxrwxr-x  2 oracle orainventory 4096 May  4 05:14 quorum.dbf
> [root at s602749nj3el19 quorum]#
>
>
> <http://www.oracle.com/>
> Keyur Patel | Principal Service Delivery Engineer | Voice:
> 919.257.2509  | cell: 551.998.4037
> Oracle Advanced Customer Services
> 8010 Arco Corporate Drive | Raleigh, NC 27617
>
>
>
>
> ------------------------------------------------------------------------
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel

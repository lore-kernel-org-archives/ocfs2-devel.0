From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Mon, 07 May 2012 18:26:58 -0700
Subject: [Ocfs2-devel] ocfs2 discontiguous localalloc patches
In-Reply-To: <20120508000100.GB4713@dhcp-172-17-9-228.mtv.corp.google.com>
References: <1336432890-18638-1-git-send-email-srinivas.eeda@oracle.com>
	<20120508000100.GB4713@dhcp-172-17-9-228.mtv.corp.google.com>
Message-ID: <4FA87662.9040006@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> On Mon, May 07, 2012 at 04:21:27PM -0700, Srinivas Eeda wrote:
>   
>> can you please review following 3 patches that implement discontiguous
>> localalloc bitmap support for ocfs2 file system. This feature helps
>> applications that significantly fragment the filesystem.
>>     
>
> 	Hi Srini.  Have you some performance numbers backing this?  That
> is, I believe that the described filesystem turned off local alloc.  Do
> you have proof that these patches, turning it back on, improved the
> customer's performance?
>
> Joel
>   
Hi Joel,

thanks a lot for the quick reply.

I have some stat_sysdir.sh snapshots at 
http://oss.oracle.com/~seeda/diag/stat_sysdir/ collected from a system. 
It has 4 snapshots collected when the file system usage is at 8%, 19%, 
21% and 52%.

In file stat_sysdir_52_percent_usage_slow_del.out, for the filesystem 
that has UUID: 3A6F54DF288C4AF2ABD1E00FC49BE7ED you could see that 
local_alloc:0000 bitmap total is 38 and is 0(disabled) for 
local_alloc:0001, and local_alloc:0002. for the filesystem that has uuid 
AC444DB162AE427C899BA89E076DD479, all localalloc appears to be disabled. 
Sorry I didn't collect /sys/kernel/debug/fs/<uuid>/fs_state. But, given 
the file system state, even if localalloc is not disabled localalloc 
need to be refilled every 40 clusters.

Thanks,
--Srini

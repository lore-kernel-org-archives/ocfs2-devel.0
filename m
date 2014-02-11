From: Xue jiufei <xuejiufei@huawei.com>
Date: Tue, 11 Feb 2014 20:42:07 +0800
Subject: [Ocfs2-devel] [patch 04/11] ocfs2: fix a tiny race when running
 dirop_fileop_racer
In-Reply-To: <20140205233106.GM24361@wotan.suse.de>
References: <20140124204703.AF70F5A4203@corp2gmr1-2.hot.corp.google.com>
	<20140205233106.GM24361@wotan.suse.de>
Message-ID: <52FA1A9F.5080702@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi, Mark
On 2014/2/6 7:31, Mark Fasheh wrote:
> On Fri, Jan 24, 2014 at 12:47:03PM -0800, akpm at linux-foundation.org wrote:
>> From: Yiwen Jiang <jiangyiwen@huawei.com>
>> Subject: ocfs2: fix a tiny race when running dirop_fileop_racer
>>
>> When running dirop_fileop_racer we found a dead lock case.
>>
>> 2 nodes, say Node A and Node B, mount the same ocfs2 volume.  Create
>> /race/16/1 in the filesystem, and let the inode number of dir 16 is less
>> than the inode number of dir race.
>>
>> Node A                            Node B
>> mv /race/16/1 /race/
>>                                   right after Node A has got the
>>                                   EX mode of /race/16/, and tries to
>>                                   get EX mode of /race
>>                                   ls /race/16/
>>
>> In this case, Node A has got the EX mode of /race/16/, and wants to get EX
>> mode of /race/.  Node B has got the PR mode of /race/, and wants to get
>> the PR mode of /race/16/.  Since EX and PR are mutually exclusive, dead
>> lock happens.
> 
> I am confused as to how this race happens.
> 
> Something like "ls /race/16' shouldn't hold locks on 'race' and '16' at the
> same time. It should look more like:
> 
> <userspace does readdir /race/16>
> PR race
> <kernel looks up '16' in 'race'>
> Unlock PR race
> PR 16
> <get dirents from '16'>
> Unlock PR 16
> <return dirents to userspace>
> 
> Can you please explain where I may be going wrong? Also an strace of the
> locked up 'ls' as well as the output of sysrq-t when it's deadlocked would
> help show what's going on.
> 	--Mark
> 
when doing 'ls /race/16', it calls vfs_fstatat->..->d_alloc()->ocfs2_lookup()
after readdir(). ocfs2_lookup() first get PR lock of race, and then get PR
lock of 16 in ocfs2_iget() without unlocking PR race.
	-- joyce.xue
> --
> Mark Fasheh
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 

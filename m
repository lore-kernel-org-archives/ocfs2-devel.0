From: Robert Smith <spamfree@wansecurity.com>
Date: Fri, 1 Jan 2010 04:36:02 +0900
Subject: [Ocfs2-devel] 40TB RAID and OCFS2 woes (inode64, JDB2,
	huge partition support,
	Volume might try to write to blocks beyond what jbd can address in 32
	bits)
In-Reply-To: <4B3CF610.4070603@oracle.com>
References: <9A9AABD3-F67F-46D3-B08C-4FD89CA16149@wansecurity.com>	<20091230203426.GA7272@mail.oracle.com>	<1D016AC1-13F8-4433-9E1D-6540302C0373@wansecurity.com>	<20091231034243.GA2560@mail.oracle.com>
	<E8CB0062-5A3B-4853-9804-8F345404A635@wansecurity.com>
	<4B3CF610.4070603@oracle.com>
Message-ID: <6575F4FA-312C-4CB4-AA92-6AF7ECEF3EEA@wansecurity.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Oh, I found it at line #2163 of fs/ocfs2/super.c.

I imagine that something as simple as the following would work, but perhaps I'll wait for your feedback.


/*
        if (ocfs2_clusters_to_blocks(osb->sb, le32_to_cpu(di->i_clusters) - 1)
            > (u32)~0UL) {
                mlog(ML_ERROR, "Volume might try to write to blocks beyond "
                     "what jbd can address in 32 bits.\n");
                status = -EINVAL;
                goto bail;
        }
*/


-Robert


On Jan 1, 2010, at 4:05 AM, Sunil Mushran wrote:

> Robert Smith wrote:
>> root at s2-replay02:/usr/src/ocfs2-tools-1.4.3# dmesg | tail -n 30 ....
>> ....
>> [ 1017.163255] OCFS2 Node Manager 1.5.0
>> [ 1017.228882] OCFS2 DLM 1.5.0
>> [ 1017.232440] ocfs2: Registered cluster interface o2cb
>> [ 1017.247862] OCFS2 DLMFS 1.5.0
>> [ 1017.248072] OCFS2 User DLM kernel interface loaded
>> [ 1032.163970] OCFS2 1.5.0
>> [ 1032.168415] (3776,6):ocfs2_initialize_super:2166 ERROR: Volume might try to write to blocks beyond what jbd can address in 32 bits.
>> [ 1032.168490] (3776,6):ocfs2_fill_super:1008 ERROR: status = -22
>> [ 1032.168525] ocfs2: Unmounting device (252,0) on (node 0)
>> [ 1220.077245] (3821,5):ocfs2_initialize_super:2166 ERROR: Volume might try to write to blocks beyond what jbd can address in 32 bits.
>> [ 1220.077306] (3821,5):ocfs2_fill_super:1008 ERROR: status = -22
>> [ 1220.077342] ocfs2: Unmounting device (252,0) on (node 0)
>> [ 1228.102152] (3834,4):ocfs2_initialize_super:2166 ERROR: Volume might try to write to blocks beyond what jbd can address in 32 bits.
>> [ 1228.102276] (3834,4):ocfs2_fill_super:1008 ERROR: status = -22
>> [ 1228.102317] ocfs2: Unmounting device (252,0) on (node 0)
>> [ 1236.126519] (3844,4):ocfs2_initialize_super:2166 ERROR: Volume might try to write to blocks beyond what jbd can address in 32 bits.
>> [ 1236.126581] (3844,4):ocfs2_fill_super:1008 ERROR: status = -22
>> [ 1236.126621] ocfs2: Unmounting device (252,0) on (node 0)
>> [ 1244.150444] (3852,4):ocfs2_initialize_super:2166 ERROR: Volume might try to write to blocks beyond what jbd can address in 32 bits.
>> [ 1244.150504] (3852,4):ocfs2_fill_super:1008 ERROR: status = -22
>> [ 1244.150539] ocfs2: Unmounting device (252,0) on (node 0)
>> root at s2-replay02:/usr/src/ocfs2-tools-1.4.3#
>> 
>> 
>> Think I need to recompile the kernel and change the built in support for JBD v1 to a module? Or modularize both of them?
>>  
> 
> The message is hard-coded. Ignore the jbd in the error message. You are using jbd2.
> 
> But that check is there for a reason. As I said before >16TB has not been tested
> thoroughly as yet. The check will be removed once we've completed the testing.

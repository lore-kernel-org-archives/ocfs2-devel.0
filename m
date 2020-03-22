From: Vasily Averin <vvs@virtuozzo.com>
Date: Sun, 22 Mar 2020 10:27:41 +0300
Subject: [Ocfs2-devel] Fwd: Re: [PATCH v2 0/4] ocfs2: seq_file .next
 functions should increase position index
In-Reply-To: <81f307f5-80cb-58b7-1089-4e1610f5d727@huawei.com>
References: <d286245b-1e54-16f4-0d87-d527e6d56648@linux.alibaba.com>
	<e954f783-5a1c-8847-7b0d-298825ee06a4@huawei.com>
	<81f307f5-80cb-58b7-1089-4e1610f5d727@huawei.com>
Message-ID: <085dc97b-de01-1d95-799d-dc795eec7818@virtuozzo.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Dear lishan,
thank you for your experiments.

Dear all, please drop my patch-set, they are incomplete.

seq_opetations used in ocfs2 are incorrect -- they ignores position index provided by seq_read().
by design .start() functions should skip first elements specified by *pos argument,
however lockres_seq_start(), ocfs2_dlm_seq_start() and other igores *pos, and uses own logic instead.

It should be reworked.

Thank you,
	Vasily Averin

On 3/21/20 7:24 AM, lishan wrote:
> test environment:
> 	kernel version: 5.6.0-rc5
> 
> lockres_seq_next -->
> /sys/kernel/debug/o2dlm/2C9B43EBE44D4715A0B0DBE4D72016A3/locking_state
> The output content is incomplete and endless, and the subsequent output is skip reading.
> The operation and print is as follows:
> dd if=/sys/kernel/debug/o2dlm/2C9B43EBE44D4715A0B0DBE4D72016A3/locking_state bs=40 skip=1
> S:1,5,0,0,0,0,0,0,0,0,3
> RMAP:
> LVBX:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
> LOCK:1,0,5,-1,5,5:1,0,0,0,0,0,0,0,0,2
> 
> NAME:M0000000000000000000042e7349704
> LRES:1,5,0,0,0,0,0,0,0,0,3
> RMAP:
> LVBX:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
> LOCK:1,0,5,-1,5,5:2,0,0,0,0,0,0,0,0,2
> ........
> NAME:M0000000000000000000042e7349704
> LRES:1,5,0,0,0,0,0,0,0,0,3
> RMAP:
> LVBX:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
> LOCK:1,0,5,-1,5,5:2,0,0,0,0,0,0,0,0,2
> 
> NAME:M0000000000000000000010e7349704
> ......
> 
> but, there is no endless output using the following script:
> linux-EalnPD:~ # q=;while read -r r;do echo "$((++q)) $r";done < /sys/kernel/debug/o2dlm/2C9B43EBE44D4715A0B0DBE4D72016A3/locking_state
> 1 NAME:S000000000000000000000200000000
> 2 LRES:1,5,0,0,0,0,0,0,0,0,3
> 3 RMAP:
> 4 LVBX:00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
> 5 LOCK:1,0,5,-1,5,5:6,0,0,0,0,0,0,0,0,2
> 6
> 7
> 8 NAME:M0000000000000000000016e7349704
> 9 NAME:M0000000000000000000018e7349704
> 10 NAME:M000000000000000000001ae7349704
> 11 NAME:M000000000000000000001ce7349704
> 12 NAME:M000000000000000000001ee7349704
> 13 NAME:M0000000000000000000020e7349704
> ....
> 534 NAME:W00000000000000000843c81d0b7768
> 535 NAME:O00000000000000000843c800000000
> 
> Other interface test results:
> nst_seq_next --> /sys/kernel/debug/o2net/send_tracking
> sc_seq_next --> /sys/kernel/debug/o2net/stats
> File content is empty, so, read it like use dd command, No effect.
> ocfs2_dlm_seq_next -->
> /sys/kernel/debug/ocfs2/2C9B43EBE44D4715A0B0DBE4D72016A3/locking_state
> Read file normal output.
> 
> And, output is still endless, after adding Vasily Averin's modifications, patch are as follow:
> [Ocfs2-devel] [PATCH v2 1/4] lockres_seq_next should increase position index   Vasily Averin
> [Ocfs2-devel] [PATCH v2 2/4] ocfs2_dlm_seq_next should increase position index   Vasily Averin
> [Ocfs2-devel] [PATCH v2 3/4] nst_seq_next should increase position index   Vasily Averin
> [Ocfs2-devel] [PATCH v2 4/4] sc_seq_next should increase position index
> 
> I added the log in seq_read, use the 'dd' read command above, print as follows:
> 2020-03-21T11:27:50.691302+08:00|notice|kernel[-]|[92756.285422] [22000/dd] --> seq_read, init, start ppos 250434, max read size 10, m->read_pos 250434, mem index 1028, mem size 4096, mem from 233, mem count 11.
> 2020-03-21T11:27:50.691328+08:00|notice|kernel[-]|[92756.285430] [22000/dd] --> seq_read, init, start ppos 250444, max read size 10, m->read_pos 250444, mem index 1028, mem size 4096, mem from 243, mem count 1.
> 2020-03-21T11:27:50.691355+08:00|notice|kernel[-]|[92756.285442] [22000/dd] --> seq_read, read start, m->read_pos 250444, mem index 1028, mem size 4096, mem from 0, mem count 0.
> 2020-03-21T11:27:50.691381+08:00|notice|kernel[-]|[92756.285444] [22000/dd] --> seq_read, before go to file, mem file count 244, mem file size 4096
> 2020-03-21T11:27:50.691406+08:00|notice|kernel[-]|[92756.285453] [22000/dd] --> seq_read, init, start ppos 250454, max read size 10, m->read_pos 250454, mem index 1029, mem size 4096, mem from 9, mem count 235.
> 2020-03-21T11:27:50.691434+08:00|notice|kernel[-]|[92756.285458] [22000/dd] --> seq_read, init, start ppos 250464, max read size 10, m->read_pos 250464, mem index 1029, mem size 4096, mem from 19, mem count 225.
> ......
> 
> I haven't figured out what the reason is, but the result is not as expected.
> 
> On 2020/3/9 16:27, piaojun wrote:
>>
>>
>>
>> -------- Forwarded Message --------
>> Subject: Re: [PATCH v2 0/4] ocfs2: seq_file .next functions should increase position index
>> Date: Wed, 26 Feb 2020 16:32:30 +0800
>> From: Joseph Qi <joseph.qi@linux.alibaba.com>
>> To: Vasily Averin <vvs@virtuozzo.com>, ocfs2-devel at oss.oracle.com, piaojun <piaojun@huawei.com>
>> CC: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>
>>
>> Looks good.
>> Jun, could you please help verify these changes and give your tested-by? Since I don't have ocfs2 cluster locally...
>>
>> Thanks,
>> Joseph
>>
>> On 2020/2/26 14:52, Vasily Averin wrote:
>>> v2: resend with improved patch description
>>>
>>> In Aug 2018 NeilBrown noticed 
>>> commit 1f4aace60b0e ("fs/seq_file.c: simplify seq_file iteration code and interface")
>>> "Some ->next functions do not increment *pos when they return NULL...
>>> Note that such ->next functions are buggy and should be fixed. 
>>> A simple demonstration is
>>>    
>>> dd if=/proc/swaps bs=1000 skip=1
>>>     
>>> Choose any block size larger than the size of /proc/swaps.  This will
>>> always show the whole last line of /proc/swaps"
>>>
>>> /proc/swaps output was fixed recently, however there are lot of other
>>> affected files and 4 of them are related to ocfs2.
>>>
>>> Unfortunately I'm not familiar with ocfs2 and cannot verify the patches locally.
>>>
>>> Usually you can observe following related problems:
>>> - read after lseek beyond end of file, described above by NeilBrown
>>>  "dd if=<AFFECTED_FILE> bs=1000 skip=1" will incorrectly generate whole last line
>>>
>>> - read after lseek on into middle of last line will output expected rest of
>>>  last line but then repeat whole last line once again. 
>>>
>>> - If .show() function generates multi-line output following bash script will never finish.
>>>
>>>  $ q=;while read -r r;do echo "$((++q)) $r";done < AFFECTED_FILE
>>>
>>> Link: https://urldefense.com/v3/__https://bugzilla.kernel.org/show_bug.cgi?id=206283__;!!GqivPVa7Brio!NwJIBH5pk_PU0nl3GdikAyWr88AIZXuC-YDPoiMU1ltEcROIRtcSY_EHVaiSzeRD-Jpafw$ 
>>>
>>> Vasily Averin (4):
>>>   lockres_seq_next should increase position index
>>>   ocfs2_dlm_seq_next should increase position index
>>>   nst_seq_next should increase position index
>>>   sc_seq_next should increase position index
>>>
>>>  fs/ocfs2/cluster/netdebug.c | 2 ++
>>>  fs/ocfs2/dlm/dlmdebug.c     | 1 +
>>>  fs/ocfs2/dlmglue.c          | 1 +
>>>  3 files changed, 4 insertions(+)
>>>
>> .
>>
>>
>> .
>>
> 

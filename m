From: Tao Ma <tao.ma@oracle.com>
Date: Sat, 02 Jan 2010 15:33:41 +0800
Subject: [Ocfs2-devel] 40TB RAID and OCFS2 woes (inode64, JDB2,
 huge partition support,
 Volume might try to write to blocks beyond what jbd can address in 32 bits)
In-Reply-To: <7DDC187D-D7DB-4640-91D7-92F7CF5CA704@wansecurity.com>
References: <9A9AABD3-F67F-46D3-B08C-4FD89CA16149@wansecurity.com>	<20091230203426.GA7272@mail.oracle.com>	<1D016AC1-13F8-4433-9E1D-6540302C0373@wansecurity.com>	<20091231034243.GA2560@mail.oracle.com>	<E8CB0062-5A3B-4853-9804-8F345404A635@wansecurity.com>	<4B3CF610.4070603@oracle.com>	<6575F4FA-312C-4CB4-AA92-6AF7ECEF3EEA@wansecurity.com>	<20091231200836.GA3301@mail.oracle.com>
	<7DDC187D-D7DB-4640-91D7-92F7CF5CA704@wansecurity.com>
Message-ID: <4B3EF6D5.7060107@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Robert,
	Great thanks for your test. I haven't met with such a big volume ever 
before. ;)

Robert Smith wrote:
> Just thought I would let you guys know that creating a 20TB file was successful. I even appended data to the end of it. Any operations on the file are completely useless because they take way to long. A appended "hello" to the end of the file no problem, but tail -n 1 {filename} yielded nothing except a lot of disk read after 159minutes of waiting.
I don't think 159 minutes is a good number.
So could you please use "strace -tttt tail -n 1 biggest_yet_file"? Just 
want to find out which system call last such a long time.
And also could you please run such command to find the disk layout of 
that file.
echo 'stat biggest_yet_file'|debugfs.ocfs2 /dev/sdx
sdx is your device of course.

btw, you said appending has no problem, so how long does it take?
And also please run "strace -ttt" to it.

Regards,
Tao

> 
> I don't really even know if this is good information or common knowledge.
> 
> dd bs=1000M count=20000 if=/dev/zero of=/data/storage/ReplayDataVolume001/biggest_yet_file
> 
> root at s2-replay02:/data/storage/ReplayDataVolume001# ls -aFl
> total 1266312192
> drwxr-xr-x 3 root root           3896 2009-12-31 23:31 ./
> drwxr-xr-x 3 root root             88 2010-01-01 11:02 ../
> -rw-r--r-- 1 root root     1048576000 2009-12-31 23:23 big_file
> -rw-r--r-- 1 root root    10485760000 2009-12-31 23:24 bigger_file
> -rw-r--r-- 1 root root   104857600000 2009-12-31 23:28 biggest_file
> -rw-r--r-- 1 root root 20971520000006 2010-01-01 11:03 biggest_yet_file
> drwxr-xr-x 2 root root           3896 2009-12-31 11:53 lost+found/
> root at s2-replay02:/data/storage/ReplayDataVolume001#
> 
> -Robert
> 
> 
> On Jan 1, 2010, at 5:08 AM, Joel Becker wrote:
> 
>> On Fri, Jan 01, 2010 at 04:36:02AM +0900, Robert Smith wrote:
>>> Oh, I found it at line #2163 of fs/ocfs2/super.c.
>>>
>>> I imagine that something as simple as the following would work, but perhaps I'll wait for your feedback.
>>>
>>>
>>> /*
>>>        if (ocfs2_clusters_to_blocks(osb->sb, le32_to_cpu(di->i_clusters) - 1)
>>>> (u32)~0UL) {
>>>                mlog(ML_ERROR, "Volume might try to write to blocks beyond "
>>>                     "what jbd can address in 32 bits.\n");
>>>                status = -EINVAL;
>>>                goto bail;
>>>        }
>>> */
>> 	That should work.  The real solution will check based on the
>> journal flags.  Be warned, there be tygers in here.
>>
>> Joel
>>
>> -- 
>>
>> "But all my words come back to me
>> In shades of mediocrity.
>> Like emptiness in harmony
>> I need someone to comfort me."
>>
>> Joel Becker
>> Principal Software Developer
>> Oracle
>> E-mail: joel.becker at oracle.com
>> Phone: (650) 506-8127
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel

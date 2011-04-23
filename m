From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 22 Apr 2011 17:22:25 -0700
Subject: [Ocfs2-devel] [Ocfs2-users] How long for an fsck?
In-Reply-To: <201104230024.35576.guerrero@ice.cat>
References: <201104211543.29963.guerrero@ice.cat>
	<201104211946.32493.guerrero@ice.cat> <4DB1F431.5070003@oracle.com>
	<201104230024.35576.guerrero@ice.cat>
Message-ID: <4DB21BC1.8080704@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 04/22/2011 03:24 PM, Josep Guerrero wrote:
>> How long did the debugfs output take?
> I think about 30 minutes. No more than 50 for sure (just by looking at the
> times of the mails).
>
>> Did fsck eventually finish?
> No. I had to cancel it after it stayed 24 hours in the same state, showing the
> same message. It never moved beyond "Pass 0a", and always was using 100% CPU
> in one core. I don't know if it would have finished on its own.
>
>> BTW, you said one of the cores was at 100%. What does top show?
>> Is fsck the main contributor or is some other process spinning?
> It was fsck (I kept a top opened the whole time, and fsck always was around
> 99% CPU usage).
>
>> I have a theory as to why it is slow. But I would like some confirmation.
>> My theory had fsck have high wait%. I seem to be missing something.
> I didn't look at the wait%, but I checked the physical disk load with iotop
> and it was very low, so it didn't look like fsck was being slow because of the
> disk. In the filesystem I successfully "fscked" before (the 3 TB one that took
> less than 60 minutes), it started doing something similar (very high CPU
> usage, low disk load) but after several minutes (when the rest of the messages
> after "Pass 0a" appeared), it did just the opposite: low CPU use, high disk
> load. Both filesystems are physically on the same set of disks (the 16TB
> logical volume is an striped LVM volume that fills about 75% of the 21 physical
> disks and the 3TB is another striped LVM volume filling the remaining space of
> the same disks) so I don't think it's a problem with the physical devices (of
> course, I could be wrong).

File a bz. This will need some investigation.

BTW, how much memory does your box have?

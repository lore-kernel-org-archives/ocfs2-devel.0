From: Gang He <ghe@suse.com>
Date: Sun, 05 May 2019 21:07:13 -0600
Subject: [Ocfs2-devel] OCFS2 with global heartbeat on DRBD devices
In-Reply-To: <b661cdca-05ae-7b70-f768-ea49dfb66a64@gmail.com>
References: <AM6PR04MB560573CC0D019D8DE3B14061ED350@AM6PR04MB5605.eurprd04.prod.outlook.com>
	<b661cdca-05ae-7b70-f768-ea49dfb66a64@gmail.com>
Message-ID: <5CCFA4E1020000F90006408F@prv1-mh.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Daniel,

Just give some comments from my view,
1) in technically, DRBD presents a block device, OCFS2 file system can use this block as its shared storage, there should not be any problem to set up a ocfs2 cluster.
2) Based on my understanding, DRBD usually provide a primary-slaver block device, but ocfs2 should need to a real shared storage, since all nodes access this shared disk simultaneously. 
I feel that DRBD does NOT handle this case under heavy pressure, though DRBD has double-primary feature.

Thanks
Gang  

>>> On 2019/5/5 at 16:19, in message
<b661cdca-05ae-7b70-f768-ea49dfb66a64@gmail.com>, Joseph Qi
<jiangqi903@gmail.com> wrote:
> Cc ocfs2-tools-devel.
> 
> Hi Daniel,
> I don't have experience on using global heartbeat on DRBD device.
> But from my understanding, I don't think there is any restriction for this 
> use case.
> 
> Thanks,
> Joseph
> 
> On 19/5/3 20:54, Daniel Sobe wrote:
>> Hi,
>> 
>> I'm wondering why the current version of the "o2cb" tool does not support 
> global heartbeat on DRBD devices.
>> 
>> Do I misunderstand the feature "global heartbeat" in that I should not use 
> it on DRBD at all?
>> 
>> I patched the "o2cb" tool to recognize DRBD devices for starting a global 
> heartbeat. Now the global heartbeat configuration with DRBD seems to work at 
> cluster start, but I wonder whether it really is that easy - or I am just 
> missing something. Maybe it failed silently and I did not notice?
>> 
>> BTW I edited file "o2cb_scandisk.c" function "add_to_list()" like this:
>> 
>>                                                if (!add)
>>                                                                add = 
> !strncmp(path->path, "/dev/rbd", 8);
>>                                                if (!add) // added
>>                                                                add = 
> !strncmp(path->path, "/dev/drbd", 9); // added
>> 
>> and by observing the output of "/proc/drbd" I can tell that the stats for 
> data read and data written on the DRBD device for the global heartbeat 
> increases, while it stays the same on all other DRBD devices. (I have not 
> mounted any of these volumes)
>> 
>> To me it looks like it works. Can anybody comment? Can I somehow "observe" 
> the proper operation of the global heartbeat?
>> 
>> Regards,
>> 
>> Daniel
>> 
>> 
>> 
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel at oss.oracle.com 
>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel 
>> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com 
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel

From: Ashish Samant <ashish.samant@oracle.com>
Date: Sun, 29 Oct 2017 15:47:01 -0700
Subject: [Ocfs2-devel] fstrim corrupts ocfs2 filesystems(become
 ready-only) on SSD device which is managed by multipath
In-Reply-To: <59F43569020000F9001C44B2@prv-mh.provo.novell.com>
References: <59F37145020000F900095631@prv-mh.provo.novell.com>
	<59F375A1.60709@oracle.com>
	<59F43569020000F9001C44B2@prv-mh.provo.novell.com>
Message-ID: <59F65A65.6090004@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 10/28/2017 12:44 AM, Gang He wrote:
> Hello Ashish,
> Thank for your reply.
>  From the patch, it looks very related to this bug.
> But one thing, I feel a little confused.
> Why was I not able to reproduce this bug in local with a SSD disk?
Hmm, thats interesting. It could be that the driver for your disk is not 
zeroing those blocks for some reason ...
You could try to simulate this by creating ocfs2 on a loop device and 
running fstrim on it.
loop converts fstrim to fallocate and puches a hole in the range, so it 
should zero out the range and
cause corruption by zeroing the group descriptor.


> There are any specific steps to reproduce this issue?

I was able to reproduce this with block size 4k and cluster size 1M. No 
other special options.

Thanks,
Ashish
> e.g. mount option for ocfs2? need to set SSD disk?
> According to the patch, the bug is not related to multipath configuration.
>
>
> Thanks
> Gang
>
>
>
>>>> Ashish Samant <ashish.samant@oracle.com> 10/28/17 2:06 AM >>>
> Hi Gang,
>
> The following patch sent to the list should fix the issue.
>
> https://patchwork.kernel.org/patch/10002583/
>
> Thanks,
> Ashish
>
>
> On 10/27/2017 02:47 AM, Gang He wrote:
>> Hello Guys,
>>
>> I got a bug from the customer, he said, fstrim command corrupted ocfs2 file system on their SSD SAN, the file system became read-only and SSD LUN was configured by multipath.
>> After umount the file system, the customer ran fsck.ocfs2 on this file system, then the file system can be mounted until the next fstrim happens.
>> The error messages were likes,
>> 2017-10-02T00:00:00.334141+02:00 rz-xen10 systemd[1]: Starting Discard unused blocks...
>> 2017-10-02T00:00:00.383805+02:00 rz-xen10 fstrim[36615]: fstrim: /xensan1: FITRIM ioctl fehlgeschlagen: Das Dateisystem ist nur lesbar
>> 2017-10-02T00:00:00.385233+02:00 rz-xen10 kernel: [1092967.091821] OCFS2: ERROR (device dm-5): ocfs2_validate_gd_self: Group descriptor #8257536 has bad signature  <<== here
>> 2017-10-02T00:00:00.385251+02:00 rz-xen10 kernel: [1092967.091831] On-disk corruption discovered. Please run fsck.ocfs2 once the filesystem is unmounted.
>> 2017-10-02T00:00:00.385254+02:00 rz-xen10 kernel: [1092967.091836] (fstrim,36615,5):ocfs2_trim_fs:7422 ERROR: status = -30
>> 2017-10-02T00:00:00.385854+02:00 rz-xen10 systemd[1]: fstrim.service: Main process exited, code=exited, status=32/n/a
>> 2017-10-02T00:00:00.386756+02:00 rz-xen10 systemd[1]: Failed to start Discard unused blocks.
>> 2017-10-02T00:00:00.387236+02:00 rz-xen10 systemd[1]: fstrim.service: Unit entered failed state.
>> 2017-10-02T00:00:00.387601+02:00 rz-xen10 systemd[1]: fstrim.service: Failed with result 'exit-code'.
>>
>> The similar bug looks like https://urldefense.proofpoint.com/v2/url?u=https-3A__bugs.launchpad.net_ubuntu_-2Bsource_util-2Dlinux_-2Bbug_1681410&d=DwIFAg&c=RoP1YumCXCgaWHvlZYR8PQcxBKCX5YTpkKY057SbK10&r=f4ohdmGrYxZejY77yzx3eNgTHb1ZAfZytktjHqNVzc8&m=Jdo98IlzJDxBqiDEhsKfqxvEt4B6WpIbZ_woY7zmLFw&s=xp0bUwpDVIHZP9g4EboYYG_1gkenzWEt_O_5KZXyFg8&e= .
>> Then, I tried to reproduce this bug in local.
>> Since I have not a SSD SAN, I found a PC server which has a SSD disk.
>> I setup a two nodes ocfs2 cluster in VM on this PC server, attach this SSD disk to each VM instance twice, then I can configure this SSD disk with multipath tool,
>> the configuration on each node likes,
>> sle12sp3-nd1:/ # multipath -l
>> INTEL_SSDSA2M040G2GC_CVGB0490002C040NGN dm-0 ATA,INTEL SSDSA2M040
>> size=37G features='1 retain_attached_hw_handler' hwhandler='0' wp=rw
>> |-+- policy='service-time 0' prio=0 status=active
>> | `- 0:0:0:0 sda 8:0  active undef unknown
>> `-+- policy='service-time 0' prio=0 status=enabled
>>     `- 0:0:0:1 sdb 8:16 active undef unknown
>>
>> Next, I do some fstrim command from each node simultaneously,
>> I also do dd command to write data to the shared SSD disk during fstrim commands.
>> But, I can not reproduce this issue, all the things go well.
>>
>> Then, I'd like to ping the list, did who ever encounter this bug?  If yes, please help to provide some information.
>> I think there are three factors which are related to this bug, SSD device type, multipath configuration and simultaneously fstrim.
>>
>> Thanks a lot.
>> Gang
>>
>>
>>
>>
>>
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel at oss.oracle.com
>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
>>
>
>
>

From: Jensen <shencanquan@huawei.com>
Date: Wed, 3 Jul 2013 09:27:12 +0800
Subject: [Ocfs2-devel] why oracle give up dlm by disk on ocfs2? because
 performance?
In-Reply-To: <20130702172030.GF32502@wotan.suse.de>
References: <51CE541B.4070807@huawei.com> <51D22B4E.6020406@huawei.com>
	<CAEeiSHWkiEiJCMjvVkAB+AGM9LUVLqw3de-tdU3K+z5=mfSF5w@mail.gmail.com>
	<51D235F8.1040503@huawei.com>
	<20130702172030.GF32502@wotan.suse.de>
Message-ID: <51D37DF0.1010704@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2013/7/3 1:20, Mark Fasheh wrote:

> On Tue, Jul 02, 2013 at 10:07:52AM +0800, Jensen wrote:
>> On 2013/7/2 9:35, Sunil Mushran wrote:
>>
>>> A general purpose file system requires one to manage over a million locks concurrently. So performance is the main reason.
>>>
>>
>> Thanks for your comments.
>>
>> Has Oracle compared the performance between ocfs2 and ocfs1?
> 
> Firstly, that's implied in the answer you just got. Also, who wouldn't
> compare performance from one version of a file system to the next?
> 
> Can you please cut to the chase and either ask what you really want to know
> or make the statement you're trying to make so we can move on?
> 


Thanks for your answer.
we want to use compare and write scsi command to replace DLM module. it is similar
with vmware vmfs.

why we want to replace dlm in ocfs2? because:
1. The stability of ocfs2 dlm is very poor, we found 100+ bug.
2. The Reliability of ocfs2 dlm is very poor, especially in network split, the
   worse case split two domain, the half of node must be reboot.
3. the maximum number of mounted machine is 32, we want to support more.

currently we worry about two thing:
1. The performance lock and unlock. because it use the scsi command and it is similar with IO read and write.
2. The change is very very large. because it maybe modify the disk layout of ocfs2.

so anyone interested with this?

> Thanks,
> 	--Mark
> 
> --
> Mark Fasheh
> 
> 

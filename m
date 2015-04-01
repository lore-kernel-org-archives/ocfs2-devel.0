From: Joseph Qi <joseph.qi@huawei.com>
Date: Wed, 1 Apr 2015 16:16:19 +0800
Subject: [Ocfs2-devel] Question about incorrect free bits setting
In-Reply-To: <55158C11.5080909@suse.de>
References: <5514BFFF.7070009@huawei.com> <55158B47.1000302@suse.com>
	<55158C11.5080909@suse.de>
Message-ID: <551BA953.7060304@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Goldwyn,
Thanks very much for the quick reply.

Hi Sunil,
Could you help provide more inputs?

Thanks,
Joseph

On 2015/3/28 0:57, Goldwyn Rodrigues wrote:
> Hi joseph,
> 
> On 03/26/2015 09:27 PM, Joseph Qi wrote:
>> Hi Goldwyn,
>> I found you posted a mail to discuss about incorrect free bits setting.
>> https://oss.oracle.com/pipermail/ocfs2-devel/2012-January/008458.html
>>
>> In this topic, Sunil said it was because of the patch added to delay
>> dropping of the dentry locks (commit ea455f8ab683) and suggested to fix
>> the quota issue in a different way.
>> Then you reverted the patches based on Honza's new way to fix the quota
>> issue.
>> https://oss.oracle.com/pipermail/ocfs2-devel/2014-February/009662.html
>>
>> I have investigated these patches and still do not know how can it
>> happen.
>> Could you please tell me more about the case that bits to be cleared
>> twice?
> 
> I am not sure how the quota patches were related. It was a long time ago.
> 
> However, what we fixed in Honza's patches is the way unlink is
> performed. The problem was we were getting very bad performance because
> of too much of journal activity. We realized that it was because the
> inodes were shown as busy and hence moved orphan directory, when they
> were not busy. It all came to the point that the open lock was still
> being held because it was delayed/offloaded to another thread.
> 
> I am not sure, but I guess that this delay may be messing up the
> accounting between the node being the owner of the lock and the one
> deleting the file (also requesting for the lock). I have not seen this
> issue for a long time now so I am not sure. Perhaps Sunil may be able to
> give more inputs.
> 
> 

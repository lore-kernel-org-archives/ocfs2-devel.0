From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Date: Wed, 2 Sep 2015 07:34:17 -0500
Subject: [Ocfs2-devel] ocfs2 version issue
In-Reply-To: <55E63E0E.1090301@oracle.com>
References: <55E50BF8.50004@oracle.com> <55E57EB0.8060207@suse.de>
	<55E63E0E.1090301@oracle.com>
Message-ID: <55E6ECC9.7040008@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 09/01/2015 07:08 PM, Srinivas Eeda wrote:

>>>
>>> Ocfs2 kernel version is removed from commit
>>> ff8fb335221e2c446b0d4cbea26be371fd2feb64 ("ocfs2: remove versioning
>>> information"), but Oracle CRS depends on this version, and this made
>>> Oracle CRS can't be installed. So i think we should revert this commit
>>> and sync this version with ocfs2-tools. Do you have any other concern
>>> about this?
>> We removed the version because it did not make sense.
> I am not sure how other kernel modules work, but for me a OCFS2
> maintaining it's own version is a good idea :). This version number
> defines the feature-set it currently supports.

The kernel version is enough to define the feature it supports. If at 
all you backport, it becomes distro-specfic.

> It also allows a
> feature-set to be backported to older kernels(if need arises).

Again, this is distro-specific and is unrelated to vanilla kernels.

>
>>   Even if we put in
>> the version back we will have to maintain it and will have a similar
>> case where the version number in the kernel is way behind the tools
>> versions because of lack of updating. Add to it the confusion of users
>> who would not know which version to quote.
> I agree that this got out of sync so probably we should fix that part
> than to remove it all together. I also don't see why tools version has
> to dictate kernel module version or vise-versa. Isn't it practical for a
> kernel module to implement a new feature-set but doesn't require any
> tools changes or vise-versa ? ;)

Yes, it is possible. For that matter, our feature bits are set in such a 
way that you can use an older tool with a newer kernel and vice-versa. 
Even if it fails, it must do gracefully. However, users are getting 
confused with the version number displayed in the ocfs2 modules.

Users had questions like "Why is indexed dir being used when we are 
using 1.5?" (and their tools were 1.8 based)

Or "I would like to use feature abc which was introduced in version 1.6 
according to the changelog. However, my ocfs2 modules version is 1.5. Is 
feature abc incorporated?"

>
>> I suggest the Oracle CRS should be modified to use the kernel version as
>> opposed to the ocfs2 kernel module specific versions.
> It may not be just Oracle CRS ... there may be other applications that
> might be using this. The problem is that we don't want a customer to
> upgrade a kernel and run into a failure which just looks bad on
> kernel/filesystem :(.  One may argue to write notes/readme's to inform
> customers but it's not practical and is a painful for some customers to
> update application software and kernel at the same time.
>

My suggestion would be to carry a distro-specific deprecating version 
patch until Oracle CRS learns to use the kernel versioning.

> Anyway, if we decide to remove the versioning forever then it may be a
> good idea to deprecate it first so applications have enough time to
> incorporate these changes. But my vote would be for ocfs2 to maintain
> it's own version number :)

While I see the problem, I fail to see why kernel version is not good 
enough for this. The only place you would require versioning is if you 
are dealing with specific hardware/firmware. I don't see any functional 
value in keeping separate versioning system for kernel modules.

-- 
Goldwyn

From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Tue, 01 Sep 2015 17:08:46 -0700
Subject: [Ocfs2-devel] ocfs2 version issue
In-Reply-To: <55E57EB0.8060207@suse.de>
References: <55E50BF8.50004@oracle.com> <55E57EB0.8060207@suse.de>
Message-ID: <55E63E0E.1090301@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Goldwyn

On 09/01/2015 03:32 AM, Goldwyn Rodrigues wrote:
> Hi Junxiao,
>
> On 08/31/2015 09:22 PM, Junxiao Bi wrote:
>> Hi Goldwyn,
>>
>> Ocfs2 kernel version is removed from commit
>> ff8fb335221e2c446b0d4cbea26be371fd2feb64 ("ocfs2: remove versioning
>> information"), but Oracle CRS depends on this version, and this made
>> Oracle CRS can't be installed. So i think we should revert this commit
>> and sync this version with ocfs2-tools. Do you have any other concern
>> about this?
> We removed the version because it did not make sense.
I am not sure how other kernel modules work, but for me a OCFS2 
maintaining it's own version is a good idea :). This version number 
defines the feature-set it currently supports. It also allows a 
feature-set to be backported to older kernels(if need arises).

>   Even if we put in
> the version back we will have to maintain it and will have a similar
> case where the version number in the kernel is way behind the tools
> versions because of lack of updating. Add to it the confusion of users
> who would not know which version to quote.
I agree that this got out of sync so probably we should fix that part 
than to remove it all together. I also don't see why tools version has 
to dictate kernel module version or vise-versa. Isn't it practical for a 
kernel module to implement a new feature-set but doesn't require any 
tools changes or vise-versa ? ;)

> I suggest the Oracle CRS should be modified to use the kernel version as
> opposed to the ocfs2 kernel module specific versions.
It may not be just Oracle CRS ... there may be other applications that 
might be using this. The problem is that we don't want a customer to 
upgrade a kernel and run into a failure which just looks bad on 
kernel/filesystem :(.  One may argue to write notes/readme's to inform 
customers but it's not practical and is a painful for some customers to 
update application software and kernel at the same time.

Anyway, if we decide to remove the versioning forever then it may be a 
good idea to deprecate it first so applications have enough time to 
incorporate these changes. But my vote would be for ocfs2 to maintain 
it's own version number :)

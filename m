From: Tristan <tristan.ye@oracle.com>
Date: Sat, 28 Nov 2009 10:49:17 +0800
Subject: [Ocfs2-devel] [PATCH 2/2] Ocfs2: Implement new OCFS2_IOC_INFO
	ioctl for ocfs2.
In-Reply-To: <87tywf4szb.fsf@basil.nowhere.org>
References: <1259310276-7782-1-git-send-email-tristan.ye@oracle.com>	<1259310276-7782-2-git-send-email-tristan.ye@oracle.com>
	<87tywf4szb.fsf@basil.nowhere.org>
Message-ID: <4B108FAD.6030208@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Andi Kleen wrote:
> Tristan Ye <tristan.ye@oracle.com> writes:
>   
>> +
>> +	/*
>> +	 * The requests series from userspace need to be NULL-terminated.
>> +	 */
>> +	do {
>> +		preq = *((POIR *)((char *)arg + i * sizeof(POIR)));
>> +		if (!preq)
>> +			break;
>> +		i++;
>>     
>
> That's the first security leak. Can be used to probe arbitary memory.
> You always need to use *_user for any user space access.
>   

Thank you for pointing this out, I'm now still learning how to hack the 
kernel codes:-)

>   
>> +
>> +	} while (preq);
>> +
>> +	num_reqs = i;
>> +
>> +	reqs = kmalloc(sizeof(POIR) * num_reqs, GFP_KERNEL);
>>     
>
> This is next root exploit. Think what happens when the user passes a very 
> large number for num_reqs that overflows the multiplication.
>
> If anything use kcalloc(). And limit the maximum size.
>   

Good point, I've checked the code, there is no need to allocate a 
pointer array for reqs.

> It's unclear why you just can't use separate ioctls for each request.
>   

A simple reason why we used NULL-terminated array to combine request 
pieces is to avoid a mass propagation of these ioctls, you know we may 
add such separated ioctols much frequently, end-user also I guess would 
be glad to tie all their requsets of this kind to one series, and 
deliver them only once.

> -Andi
>   
Tristan.

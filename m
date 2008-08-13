From: Marcos E. Matsunaga <Marcos.Matsunaga@oracle.com>
Date: Wed, 13 Aug 2008 16:47:33 -0400
Subject: [Ocfs2-devel] [PATCH 0/3] Dynamic local alloc (halfway there)
In-Reply-To: <20080813195248.GN21187@wotan.suse.de>
References: <1217536922-28328-1-git-send-email-mfasheh@suse.com>
	<48A331A9.7000404@oracle.com>
	<20080813195248.GN21187@wotan.suse.de>
Message-ID: <48A34865.1020003@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Overall, it runs faster.. a 10 cycle test would take a whole weekend and 
not finish. I ran a complete 30+cycles over the weekend.

Regards,

Marcos Eduardo Matsunaga

Oracle USA
Linux Engineering

?The statements and opinions expressed here are my own and do not
necessarily represent those of Oracle Corporation.?



Mark Fasheh wrote:
> On Wed, Aug 13, 2008 at 03:10:33PM -0400, Marcos E. Matsunaga wrote:
>   
>> The times in average goes up 3-4 times and then comes back to normal. I had
>> some hard times with the kernel because at some point it starts to dump stacks
>> for processes that stay too long without responding. Some of the systems had
>> times over 3-4 times going up to about 10 times, but my guess is that it was
>> related to the dumps as the systems get very slow at that point.
>>     
>
> Ok, so we're doing much better - where it would slow down by about 50 times
> before. How about overall run time? Is that affected at all? Do we complete
> the whole test faster than before, or does the run time stay the same?
>
>
>   
>> I'm planning to leave it running again, but disabling the dumps. I'm not really
>> sure it will have much of an effect in terms of performance impact, but I'll
>> try.
>>     
>
> Well, it's certainly worth knowing  :)
> 	--Mark
>
> --
> Mark Fasheh
>   
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20080813/ce7c3703/attachment.html 

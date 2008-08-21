From: TaoMa <tao.ma@oracle.com>
Date: Thu, 21 Aug 2008 10:30:25 +0800
Subject: [Ocfs2-devel] [PATCH 07/16] Add extent tree operation for xattr
 value.
In-Reply-To: <20080821021846.GC28632@mail.oracle.com>
References: <48A929A4.90103@oracle.com>
	<1219052334-10415-7-git-send-email-tao.ma@oracle.com>
	<20080821005737.GB28632@mail.oracle.com>
	<48ACBECD.4010506@oracle.com> <20080821012106.GC4563@wotan.suse.de>
	<48ACC65C.9020008@oracle.com> <20080821020255.GD4563@wotan.suse.de>
	<48ACCF74.1000900@oracle.com>
	<20080821021846.GC28632@mail.oracle.com>
Message-ID: <48ACD341.8000705@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> On Thu, Aug 21, 2008 at 10:14:12AM +0800, TaoMa wrote:
>   
>> Mark Fasheh wrote:
>>     
>>> It should *not* depend on sparse. I'm pretty sure we discussed this
>>> already...
>>>   
>>>       
>> Sorry for my bad memory :(, but I really can't recall it.
>> As for xattr tree, we should have a very large possibility that we will  
>> have a sparse tree because of the hash value.
>> So we don't allow the user to use extent tree when he doesn't set  
>> "sparse"? only large ea are supported then?
>> That also means I should add another bug fix to check whether the sparse  
>> is enabled when creating a xattr tree.
>>     
>
> 	You can support sparse EAs even if sparse *files* are disabled.
> The kernel has the sparse handling code already if INCOMPAT_XATTR is set.
>   
aha, yes. I misunderstand it. ;)
Thanks for explanation.

Regards,
Tao

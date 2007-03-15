From: Sunil Mushran <Sunil.Mushran@oracle.com>
Date: Thu Mar 15 15:23:55 2007
Subject: [Ocfs2-devel] Strange panics on ocfs2-1.2 svn rev 2988:2990
In-Reply-To: <45F9C0E3.8040803@terra.com.br>
References: <45F9B4D9.2050207@terra.com.br> <45F9B696.1060506@oracle.com>
	<45F9C0E3.8040803@terra.com.br>
Message-ID: <45F9C776.6030705@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

One of them oopsed during usb scanning and one during cache_reap.
Unsure how they could be related to ocfs2.

Marcus Alves Grando wrote:
> Sunil Mushran wrote:
>   
>> You'll have to be lot more specific.... especially considering you are
>> working directly of an svn tree. For starters, where is the server hung?
>>     
>
> Ok It's true.
>
> Let's start again.
>
> After make svn up and make packages with svn rev 2990. Two servers
> doesn't reboot after "shutdown -r now". After look on console both
> servers have panic message.
>
> Two panic's attached.
>
> Thanks
>
>   
>> Marcus Alves Grando wrote:
>>     
>>> Hi developers,
>>>
>>> After svn up ocfs2-1.2 tree from 2987 to 2990 i have strange problems.
>>> My servers are four RH AS4u4 with kernel-hugemem. When i execute
>>> "shutdown -r now" in four server some servers reboot some not, with and
>>> without changing idle_timeout_ms.
>>>
>>> Any fix for that?
>>>
>>> Regards
>>>
>>>   
>>>       
>
>   

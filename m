From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Thu, 17 Jun 2010 01:35:10 -0700
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2 fix o2dlm dlm run purgelist
In-Reply-To: <20100617083216.GA17748@mail.oracle.com>
References: <1276663383-8238-1-git-send-email-srinivas.eeda@oracle.com>
	<4C197E0B.1060103@oracle.com>
	<20100617083216.GA17748@mail.oracle.com>
Message-ID: <4C19DE3E.9080701@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 6/17/2010 1:32 AM, Joel Becker wrote:
> On Wed, Jun 16, 2010 at 06:44:43PM -0700, Sunil Mushran wrote:
>   
>> One way to skip a lockres in the purgelist is to list_del_init() and
>> list_add_tail(). That simplifies the patch a lot.
>>
>> I have attached a quick & dirty patch. See if that satisfies all the
>> requirements.
>>     
>
> 	As far as I can tell from reading the code, the time_after()
> check is because they are time ordered.  Wouldn't moving it to the end
> violate that?
>   
right. that's why I didn't want to move used lockres to tail :)
> Joel
>
>   
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20100617/ef913653/attachment.html 

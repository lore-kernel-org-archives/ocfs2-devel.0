From: SRINIVAS EEDA <srinivas.eeda@oracle.com>
Date: Mon, 22 Mar 2010 19:21:58 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] dlm: fix a race in lockres mastery
In-Reply-To: <20100323014724.GC12279@mail.oracle.com>
References: <1269301847-32101-1-git-send-email-srinivas.eeda@oracle.com>
	<4BA80E47.70307@oracle.com>
	<20100323011523.GA12279@mail.oracle.com>
	<4BA81760.7030902@oracle.com>
	<20100323014724.GC12279@mail.oracle.com>
Message-ID: <4BA825C6.1050706@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Sunil, Joel, thanks for modifying the comments :)

On 3/22/2010 6:47 PM, Joel Becker wrote:
> On Mon, Mar 22, 2010 at 06:20:32PM -0700, Sunil Mushran wrote:
>   
>> yes, your wording is better. and yes, dlm->spinlock is the
>> top level lock.
>>     
>
> 	This patch is now in the 'fixes' branch of ocfs2.git.
>
> Joel
>
>   
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20100322/c2897bf0/attachment.html 

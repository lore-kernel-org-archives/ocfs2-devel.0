From: Joel Becker <Joel.Becker@oracle.com>
Date: Wed, 20 Aug 2008 19:18:46 -0700
Subject: [Ocfs2-devel] [PATCH 07/16] Add extent tree operation for	xattr
	value.
In-Reply-To: <48ACCF74.1000900@oracle.com>
References: <48A929A4.90103@oracle.com>
	<1219052334-10415-7-git-send-email-tao.ma@oracle.com>
	<20080821005737.GB28632@mail.oracle.com>
	<48ACBECD.4010506@oracle.com> <20080821012106.GC4563@wotan.suse.de>
	<48ACC65C.9020008@oracle.com> <20080821020255.GD4563@wotan.suse.de>
	<48ACCF74.1000900@oracle.com>
Message-ID: <20080821021846.GC28632@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Aug 21, 2008 at 10:14:12AM +0800, TaoMa wrote:
> Mark Fasheh wrote:
>> It should *not* depend on sparse. I'm pretty sure we discussed this
>> already...
>>   
> Sorry for my bad memory :(, but I really can't recall it.
> As for xattr tree, we should have a very large possibility that we will  
> have a sparse tree because of the hash value.
> So we don't allow the user to use extent tree when he doesn't set  
> "sparse"? only large ea are supported then?
> That also means I should add another bug fix to check whether the sparse  
> is enabled when creating a xattr tree.

	You can support sparse EAs even if sparse *files* are disabled.
The kernel has the sparse handling code already if INCOMPAT_XATTR is set.

Joel

-- 

Dort wo man B?cher verbrennt, verbrennt man am Ende auch Mensch.
(Wherever they burn books, they will also end up burning people.)
	- Heinrich Heine

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127

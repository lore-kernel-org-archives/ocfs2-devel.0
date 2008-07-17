From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 17 Jul 2008 11:01:40 -0700 (PDT)
Subject: [Ocfs2-devel] [git patches] Ocfs2 and Configfs updates for
	2.6.27
In-Reply-To: <20080717175146.GH28014@wotan.suse.de>
References: <20080717175146.GH28014@wotan.suse.de>
Message-ID: <alpine.LFD.1.10.0807171056520.2959@woody.linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mark Fasheh <mfasheh@suse.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>, Andrew Morton <akpm@linux-foundation.org>



On Thu, 17 Jul 2008, Mark Fasheh wrote:
> 
> The only two things that could be described as features would be:
> 
> - Joel updated configfs's ->make_item() and ->make_group() callbacks to
>   return more descriptive error types. This update is responsible for the
>  changes to drivers/net/netconsole.c and fs/dlm/config.c as shown in the diffstat.


.. I really dislike how this was done.

This commit:

11c3b79218390a139f2d474ee1e983a672d5839a ("configfs: Allow ->make_item() 
and ->make_group() to return detailed errors.")

is just ugly. Returning one value by passing a pointer to a pointer, and 
the error value by returning an 'int' errno is _not_ how we do things in 
the kernel.

No, we use error pointers. 

IOW, you should have left the calling convention for "(*make_item)()" and 
"(*make_group)()" alone, but allowed people to just do

	return ERR_PTR(-ENOMEM);

etc for errors, and then in the caller you just check for IS_ERR().

That would have made the result much cleaner, and avoided that whole 
"return two different things" issue.

I pulled it, but I want to register my protest.

			Linus

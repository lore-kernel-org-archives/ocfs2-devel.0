From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Tue Jun 12 17:19:08 2007
Subject: [Ocfs2-devel] Re: [KJ PATCH] Replacing memset(<addr>, 0,
	PAGE_SIZE) with clear_page() in fs/ocfs2/dlm/dlmrecovery.c
In-Reply-To: <1181534899.2300.16.camel@shani-win>
References: <1181534899.2300.16.camel@shani-win>
Message-ID: <20070613001903.GH20632@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Jun 11, 2007 at 09:38:19AM +0530, Shani Moideen wrote:
> Replacing memset(<addr>,0,PAGE_SIZE) with clear_page() in
> fs/ocfs2/dlm/dlmrecovery.c

Ok, that looks good - thanks.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com

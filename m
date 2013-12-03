From: Mark Fasheh <mfasheh@suse.de>
Date: Mon, 2 Dec 2013 16:06:35 -0800
Subject: [Ocfs2-devel] [PATCH] Remove versioning information
In-Reply-To: <20131126233722.GA20032@shrek.lan>
References: <20131126233722.GA20032@shrek.lan>
Message-ID: <20131203000635.GC16774@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Nov 26, 2013 at 05:37:27PM -0600, Goldwyn Rodrigues wrote:
> The versioning information is confusing for end-users. The numbers
> are stuck at 1.5.0 while the tools version have moved to 1.8.2.
> 
> I suggest removing the versioning system in the ocfs2 module and let
> the kernel version be the guide to debug issues. However, if
> you think versioning is still required, please state the reason and
> modify the version string in the *ver.h files.

Thanks for this. Once upon a time the versioning helped us but these days
it's just outdated info

I would keep the module description if you don't mind. Something short and
straight forward:

MODULE_DESCRIPTION("Ocfs2 cluster file system");

I don't know that we really need a description for the other two modules.
	--Mark

--
Mark Fasheh

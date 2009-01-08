From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 07 Jan 2009 17:09:17 -0800
Subject: [Ocfs2-devel] [Ocfs2-tools-devel] [PATCH 1/2] mkfs.ocfs2:
 Update fs-features list in man page
In-Reply-To: <20090108005540.GW17410@wotan.suse.de>
References: <1230330267-1975-1-git-send-email-mfasheh@suse.com>
	<4963EDF0.3020600@oracle.com>
	<20090108005540.GW17410@wotan.suse.de>
Message-ID: <4965523D.5090609@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mark Fasheh wrote:
> Sounds good. I left the last one '--no-backup-super' there and marked it
> deprecated though. I figure it's best to keep it documented until we remove
> it from mkfs.ocfs2 altogether.

ok.

> Done, though I'm starting to wonder about us versioning the features like
> that. A lot of distro kernels will have these features applied even though
> the actual version number is lower.

By distro I am assuming you mean enterprise kernels. That is always
a pain to document. I have tried to keep the tools mainline centric.
Enterprise users have a user's guide as the reference.

I think this will sort itself out as ocfs2 in enterprise distros is closer
to the mainline kernel.

The other option is not to mention the version. But then we hurt the
non-enterprise users for whom we have no other docs.

> Erm, and then we'll be left with the same situation as --fs-features where
> one gets updated and the other doesn't, etc... I think what *was* a mistake
> was me not putting a pointer to mkfs.ocfs2.8 for --journal-options...

Sure. That will work.

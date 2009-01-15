From: Mark Fasheh <mfasheh@suse.com>
Date: Wed, 14 Jan 2009 18:19:38 -0800
Subject: [Ocfs2-devel] [PATCH 0/5] OCFS2 quota fixes
In-Reply-To: <1231798833-6850-1-git-send-email-jack@suse.cz>
References: <1231798833-6850-1-git-send-email-jack@suse.cz>
Message-ID: <20090115021938.GA17410@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Jan 12, 2009 at 11:20:28PM +0100, Jan Kara wrote:
> Hello,
> 
> the following series of patches fixes some issues with OCFS2 quotas.
> The first patch modifies VFS quota locking, the next patch uses the
> fact to simplify OCFS2 quota locking and solves a few deadlock issues.
> The third and the fourth patches fix another possible deadlocks in OCFS2
> quota code and the last patch is a minor cleanup.
Ok, patches 1-4 are in Ocfs2.git. I think we should send them upstream
during this cycle. Do you want to post these on linux-fsdevel too?
        --Mark        


--
Mark Fasheh

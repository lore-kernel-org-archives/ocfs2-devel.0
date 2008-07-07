From: Mark Fasheh <mfasheh@suse.com>
Date: Mon, 7 Jul 2008 11:20:23 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2/dlm: Fixes oops in
	dlm_new_lockres()
In-Reply-To: <1215450389-7297-1-git-send-email-sunil.mushran@oracle.com>
References: <1215450389-7297-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20080707182023.GC28100@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Mon, Jul 07, 2008 at 10:06:29AM -0700, Sunil Mushran wrote:
> Patch fixes a race that can result in an oops while adding a
> lockres to the dlm lockres tracking list.
> 
> Bug introduced by mainline commit 29576f8bb54045be944ba809d4fca1ad77c94165.

Ok, looks good... What's the impact? This looks like perhaps I should be
pushing up upstream asap...
	--Mark

--
Mark Fasheh

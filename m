From: Mark Fasheh <mfasheh@suse.de>
Date: Fri, 18 Dec 2015 14:34:27 -0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: return non-zero st_blocks for
	inline data
In-Reply-To: <1448399221-6109-2-git-send-email-john.haxby@oracle.com>
References: <1448399221-6109-1-git-send-email-john.haxby@oracle.com>
	<1448399221-6109-2-git-send-email-john.haxby@oracle.com>
Message-ID: <20151218223427.GI11072@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Nov 24, 2015 at 09:07:01PM +0000, John Haxby wrote:
> Some versions of tar assume that files with st_blocks == 0 do not
> contain any data and will skip reading them entirely. See also
> commit 9206c561554c ("ext4: return non-zero st_blocks for inline data").
> 
> Signed-off-by: John Haxby <john.haxby@oracle.com>
Reviewed-by: Mark Fasheh <mfasheh@suse.de>

--
Mark Fasheh

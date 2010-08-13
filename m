From: Mark Fasheh <mfasheh@suse.com>
Date: Fri, 13 Aug 2010 16:28:37 -0700
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2: Fix metaecc error messages
In-Reply-To: <1281655466-26341-1-git-send-email-sunil.mushran@oracle.com>
References: <1281655466-26341-1-git-send-email-sunil.mushran@oracle.com>
Message-ID: <20100813232837.GL17779@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Aug 12, 2010 at 04:24:25PM -0700, Sunil Mushran wrote:
> Like tools, the checksum validate function now prints the values in hex.
> 
> Signed-off-by: Sunil Mushran <sunil.mushran@oracle.com>

Acked-by: Mark Fasheh <mfasheh@suse.com>

And thanks, this was rather annoying when I was last comparing checksums
between different parts of the code / project.
	--Mark

--
Mark Fasheh

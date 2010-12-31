From: Christoph Hellwig <hch@lst.de>
Date: Fri, 31 Dec 2010 14:10:20 +0100
Subject: [Ocfs2-devel] [PATCH 00/34] OCFS2: Add trace event and replace
	mlog(0).
In-Reply-To: <4D12F7E7.1090204@tao.ma>
References: <4D12F7E7.1090204@tao.ma>
Message-ID: <20101231131020.GA27129@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I really don't like the way this is split into tons of patches, which
makes reviewing what's going on pretty hard.  In addition to the
preparatiory patch just one patch is more than enough, or if you really
want two: one to remove the old mlog code and one to add the trace
events.

From: Sunil Mushran <Sunil.Mushran@oracle.com>
Date: Tue Aug  3 14:34:38 2004
Subject: [Ocfs2-devel] Calculating volume size from superblock
In-Reply-To: <60C14C611F1DDD4198D53F2F43D8CA3B01864F52@orsmsx410>
References: <60C14C611F1DDD4198D53F2F43D8CA3B01864F52@orsmsx410>
Message-ID: <1091561587.15383.13.camel@smushran-pc1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

> So the global bitmap size changes on a regular basis?

well, ocfs v1 already has the resizing capability, so no reason why v2
will not have that. Infact, with the current layout, we could even
provide hot resizing.

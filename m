From: Daniel Phillips <phillips@google.com>
Date: Wed, 03 May 2006 16:04:30 -0700
Subject: [Ocfs2-devel] OCFS2 features RFC - separate journal?
In-Reply-To: <20060425183553.GB10524@ca-server1.us.oracle.com>
References: <20060425183553.GB10524@ca-server1.us.oracle.com>
Message-ID: <445936FE.90401@google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mark Fasheh wrote:
> The OCFS2 team is in the preliminary stages of planning major features for
> our next cycle of development. The goal of this e-mail then is to stimulate
> some discussion as to how features should be prioritized going forward. Some
> disclaimers apply:

Hi guys,

Sorry about the lag.  Here's an easy feature nobody has mentioned so far, and
from my reading isn't supported: separate journal, like Ext3.  The journals
stay per-node, but they can be on a different (shared) volume than the
filesystem proper.  This should be dead simple to do and it can make a huge
difference to write latency, by putting the journals on separate spindles or
(what I actually have in mind) in NVRAM.

Regards,

Daniel

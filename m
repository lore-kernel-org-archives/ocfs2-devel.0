From: abeekhof@suse.de <abeekhof@suse.de>
Date: Mon Dec  4 05:12:42 2006
Subject: [Ocfs2-devel] [patch 0/3] OCFS Configurable timeouts - Revision 5
Message-ID: <20061204130452.199246000@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Minor improvements to the handshake logic
- Ensure failed handshakes are only processed once
- Skip the o2net_msg code after a sucessful handshake

Do we need logic to handle inbound messages that arrive before a valid handshake?  Or does this not happen?

--

Andrew

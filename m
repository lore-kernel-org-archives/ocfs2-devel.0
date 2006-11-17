From: abeekhof@suse.de <abeekhof@suse.de>
Date: Fri Nov 17 23:36:39 2006
Subject: [Ocfs2-devel] [patch 0/3] OCFS Configurable timeouts from userspace
Message-ID: <20061118073600.206222000@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

--

Jeff has asked me to finish off his configurable timeouts patch.... 
here's the results :-)

One thing I'm not so happy about are the changes (I made) to o2net_msg struct 
in order to satisfy the logic in o2net_check_handshake()

Presumably the logic in o2net_check_handshake() should be changed?

Andrew

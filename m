From: Goldwyn Rodrigues <rgoldwyn@gmail.com>
Date: Thu, 11 Nov 2010 19:01:30 -0600
Subject: [Ocfs2-devel] [PATCH 0/2] Parallel Journal Replay
Message-ID: <AANLkTimrwjLdwZYGz64Y7s+XUR63600N1nWf5r5=+8aF@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Parallel Journal replay allows faster recovery by replaying journal in
parallel. The ocfs2rec thread spawns a new thread for each node which
needs recovery and the thread is reponsible for performing the journal
replay.

To achieve this, the recovery map has been converted into a list and an
element of the list are passed to the per-node recovery thread.

-- 
Goldwyn

From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 01 Oct 2010 15:09:45 -0700
Subject: [Ocfs2-devel] odirect hack
Message-ID: <4CA65C29.7030001@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mark,

I was discussing with Joel whether it was time for us to special
case the odirect hack we've had since day 1. The one that allows
concurrent odirect writes.

I am wondering whether we should allow users control that behavior
via a mount option. parallel_directio, maybe.

Sunil

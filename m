From: Lars Marowsky-Bree <lmb@suse.de>
Date: Tue Oct 25 10:54:44 2005
Subject: [Ocfs2-devel] Support for SLES9
In-Reply-To: <15538.193.5.216.100.1130229159.squirrel@www2.calivia.com>
References: <15538.193.5.216.100.1130229159.squirrel@www2.calivia.com>
Message-ID: <20051025155427.GA18070@marowsky-bree.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2005-10-25T10:32:39, Michael Steinmann <msl@calivia.com> wrote:

> Support for SLES9 seems to be pretty much lacking at the moment.

This is not true, hopefully.

> The OCFS2 site [1] states OCFS2 is supported with SP2+. There actually
> does not exist a SP2+ for SLES9 (or should this rather read "will be
> supported in SP3" instead?).

It measn "SP2 and up".

> Latest RPMs that come with SLES9 SP2 are 0.99.14 which has critical known
> bugs and is unusable.

The in-kernel version is much higher, which is where the critical bugs
have been fixed.

A later user-space version has not been deemed necessary yet; if you
have a support contract and require it, please file a request.

> Anybody got to compile current source on SLES9 x86_64?
> 1.1.2, 1.1.6 and trunk all fail to compile on SLES9.SP2
> 2.6.5-7.191-smp SMP x86_64 [3].

SP2 only officially supports OCFS2 1.0.x.

We will include 1.1/1.2 in SP3.

> Problem here is that we loose IP heartbeat and node1 fences shortly after
> mounting a shared LV on the second node [4]. Bummer.

Please file a support request with Novell.


Sincerely,
    Lars Marowsky-Br?e <lmb@suse.de>

-- 
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"

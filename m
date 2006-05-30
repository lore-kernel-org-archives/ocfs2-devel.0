From: Lars Marowsky-Bree <lmb@suse.de>
Date: Tue, 30 May 2006 21:38:48 +0200
Subject: [Ocfs2-devel] [RFC] Fencing harness for OCFS2
In-Reply-To: <44767695.7000203@google.com>
References: <44767695.7000203@google.com>
Message-ID: <20060530193848.GP17040@marowsky-bree.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2006-05-25T20:31:33, Daniel Phillips <phillips@google.com> wrote:

> Goals:
>     - Lightweight, kernel based fencing harness
>     - Support pluggable fencing methods
>     - Pluggable methods take policy out of kernel
>     - No reinvented wheels, use kernel modules
>     - Also accomodate user space fencing methods
>     - Divide work appropriately between kernel and user space
>     - Obey memory deadlock prevention rules
>     - Obey safe module unload rules
>     - Handle multiple clusters per node

Sorry we're chiming in so late, but with Jeff's user-space membership
patches, we have user-space driven fencing working with heartbeat 2.


Sincerely,
    Lars Marowsky-Br?e

-- 
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"

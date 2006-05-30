From: Daniel Phillips <phillips@google.com>
Date: Tue, 30 May 2006 12:45:52 -0700
Subject: [Ocfs2-devel] [RFC] Fencing harness for OCFS2
In-Reply-To: <20060530193848.GP17040@marowsky-bree.de>
References: <44767695.7000203@google.com>
	<20060530193848.GP17040@marowsky-bree.de>
Message-ID: <447CA0F0.5020203@google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Lars Marowsky-Bree wrote:
> On 2006-05-25T20:31:33, Daniel Phillips <phillips@google.com> wrote:
> 
>>Goals:
>>    - Lightweight, kernel based fencing harness
>>    - Support pluggable fencing methods
>>    - Pluggable methods take policy out of kernel
>>    - No reinvented wheels, use kernel modules
>>    - Also accomodate user space fencing methods
>>    - Divide work appropriately between kernel and user space
>>    - Obey memory deadlock prevention rules
>>    - Obey safe module unload rules
>>    - Handle multiple clusters per node
> 
> Sorry we're chiming in so late, but with Jeff's user-space membership
> patches, we have user-space driven fencing working with heartbeat 2.

Which patches?  For OCFS2?  If so, then what have you done to avoid
memory deadlock?

Regards,

Daniel

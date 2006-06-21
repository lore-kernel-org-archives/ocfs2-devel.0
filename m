From: Sunil Mushran <Sunil.Mushran@oracle.com>
Date: Wed, 21 Jun 2006 12:17:31 -0700
Subject: [Ocfs2-devel] [git patches] ocfs2 fixes
In-Reply-To: <1150916457.5288.63.camel@brilong-lnx>
References: <20060621184316.GA19085@ca-server1.us.oracle.com>
	<1150916457.5288.63.camel@brilong-lnx>
Message-ID: <44999B4B.6000500@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Typically all bugs are fixed on 1.2.x and then rolled forward to git.
Features follow the opposite route.

We don't yet have a date for 1.2.2.

Brian Long wrote:
> On Wed, 2006-06-21 at 11:43 -0700, Mark Fasheh wrote:
>   
>> Please pull from 'upstream-linus' branch of
>> git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git
>>
>> to receive the following updates:
>>
>>  fs/ocfs2/dlm/dlmast.c      |   12 
>>  fs/ocfs2/dlm/dlmcommon.h   |   63 ++++
>>  fs/ocfs2/dlm/dlmconvert.c  |   24 +
>>  fs/ocfs2/dlm/dlmdebug.c    |    6 
>>  fs/ocfs2/dlm/dlmdebug.h    |   30 --
>>  fs/ocfs2/dlm/dlmdomain.c   |  101 +++++--
>>  fs/ocfs2/dlm/dlmfs.c       |    6 
>>  fs/ocfs2/dlm/dlmlock.c     |   68 ++++-
>>  fs/ocfs2/dlm/dlmmaster.c   |  448 +++++++++++++++++++++++-----------
>>  fs/ocfs2/dlm/dlmrecovery.c |  580 ++++++++++++++++++++++++++++++++++-----------
>>  fs/ocfs2/dlm/dlmthread.c   |   68 ++++-
>>  fs/ocfs2/dlm/dlmunlock.c   |   10 
>>  fs/ocfs2/dlm/userdlm.c     |    2 
>>  13 files changed, 1045 insertions(+), 373 deletions(-)
>>     
>
> Hi Mark et al,
>
> When you send a huge patch like this to Linus, can we assume all these
> patches are already integrated into the released RPMs on
> http://oss.oracle.com for RHEL 4?
>
> Also, what is your typical release schedule for rolling up bugs and
> releasing a point release?  For example, I see in
> http://oss.oracle.com/~smushran/.ocfs2-1.2.1-3/README that this version
> is there until 1.2.2 is released?  Do you have a target for 1.2.2?  Will
> it include other bug fixes?
>
> /Brian/
>   

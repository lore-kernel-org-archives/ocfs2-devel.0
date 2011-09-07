From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 07 Sep 2011 11:08:57 -0700
Subject: [Ocfs2-devel] block64 failure
In-Reply-To: <20110907175748.GA17687@noexit.corp.google.com>
References: <4E67A593.70302@oracle.com>
	<20110907175748.GA17687@noexit.corp.google.com>
Message-ID: <4E67B339.8050509@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 09/07/2011 10:57 AM, Joel Becker wrote:
> On Wed, Sep 07, 2011 at 10:10:43AM -0700, Sunil Mushran wrote:
>> All,
>>
>> So the patches added to allow mounting volumes>  16TB has a problem.
>> The feature check of the jbd2 superblock is being done before the
>> jbd2 superblock is actually read.
>>
>> It is being done after the journal_init_inode() which is incorrect.
>>
>> ocfs2_check_volume()
>>    ocfs2_journal_init()
>>         jbd2_journal_init_inode()
>>    ocfs2_journal_addressable()<=== check
>> ...
>>
>> Currently the journal sb is first read during load_journal. Too late for us.
>> And journal_get_superblock() is not exported.
> 	I'm confused.  jbd2_journal_check_used_features() reads the
> journal superblock if needed.  Why does this not satisfy?

oops. you are correct as always. I missed that patch.

Sorry for the noise.

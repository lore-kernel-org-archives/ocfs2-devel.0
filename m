From: Gang He <ghe@suse.com>
Date: Wed, 27 Sep 2017 20:11:48 -0600
Subject: [Ocfs2-devel] ocfs2-test supports Python 3
In-Reply-To: <3c4a2be8-4332-1e5a-7047-8dc872d745cb@suse.com>
References: <59CBB7F0020000F90008F634@prv-mh.provo.novell.com>
	<3c4a2be8-4332-1e5a-7047-8dc872d745cb@suse.com>
Message-ID: <59CCCAE4020000F90008F95F@prv-mh.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com




>>> 
> Hi,
> 
>> As you know, some Linux distributions(e.g. SUSE Enterprise Linux 15) will 
> introduce Python3 as the default,
>> our Python scripts in ocfs2-test still use Python2, we will have to do 
> proper modifications to migration to Python3 (Larry Chen has worked on this 
> investigation).
>> But, the problem is how to maintain the ocfs2-test code between Python2 and 
> Python3? since some existing Linux distributions(include their further SP) 
> use Python2.
>> there are two options,
>> 1) one code branch, in which the code is compatible with Python2 and 
> Python3, but I feel it is difficult after I talked with Larry Chen.
>> 2) two code branches, one branch is for Python2, the other branch is for 
> Python3.
>> what are your thoughts? please let us know, then we can select a way to work 
> on this task.
> I think we can make a "snapshot" branch of current master, i.e. name it 
> as "snapshot-2017.9", and don't change that branch anymore.
> For users who want to test ocfs2 on OS with python2, they can use it 
> without problems, and we should document this in README.txt.
> 
> For the python3 and other changes,  we can merge them into master 
> branch, making master move on forward...
Maybe we can fork a code branch "master-py3", then we can work on that code branch.
Currently, I feel more users still use python2 for ocfs2-test.

Thanks
Gang


> 
> Eric

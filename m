From: Joseph Qi <jiangqi903@gmail.com>
Date: Fri, 29 Mar 2019 10:21:22 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: fix ocfs2 read inode data panic in
 ocfs2_iget
In-Reply-To: <e224f7e3-ad4e-b348-08dd-cf64993879c2@oracle.com>
References: <1553477217-2736-1-git-send-email-sunny.s.zhang@oracle.com>
	<01433584-44d5-5b27-a0c9-fff4bff74864@gmail.com>
	<ab0a6ca7-2f6a-b738-72ce-4ffb6787aad2@oracle.com>
	<5C9846C7020000F90005B029@prv1-mh.provo.novell.com>
	<4b7dee86-52fe-d383-296e-5ce1bb7ef178@oracle.com>
	<e224f7e3-ad4e-b348-08dd-cf64993879c2@oracle.com>
Message-ID: <f4a83860-8e81-3a2e-66e0-bebc0c8e3426@gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 19/3/29 09:05, sunny.s.zhang wrote:
> Hi Gang,? Jiang Qi,? Joseph,
> 
> Is my description clear?
> Are there any other suggestions?
> In addition, it works fine on ext4.

So this happens when using ocfs2 as NFSv3 backend, right?
If so, please describe the use case in commit log as well as the
sequence how it happens.

BTW, since the dinode has been deleted, the block may be used in other
way. So I don't think we can use "di->i_dtime != 0" to identify this
case.

Thanks,
Joseph

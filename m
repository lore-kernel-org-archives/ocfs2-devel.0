From: jiangyiwen <jiangyiwen@huawei.com>
Date: Tue, 1 Mar 2016 11:19:14 +0800
Subject: [Ocfs2-devel]  [RFC] ocfs2: Double about ocfs2_trylock_journal
Message-ID: <56D50A32.8060505@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

ocfs2_trylock_journal() is used to test if the node who occupied this
slot is alive in ocfs2_mark_dead_nodes(), but actually it can't achieve
the desired results. The problem can be described as follows:

N1              N2                        N3
crash, previously
occupied in slot 1
                begin mount, only have
                N2,N3 in domain_map,
                and found slot 1 is occupied,
                then call ocfs2_trylock_journal()
                                          N3 is lockres master of
                                          journal:0001, but N3 doesn't
                                          find N1 down, so return
                                          DLM_NOTQUEUED to N2
                Because N3 doesn't find N1
                down, so ocfs2_trylock_journal()
                return EAGAIN, and will not
                recover N1
                                          in this moment, N3 crash
                N2 only recover N3 in this
                situation, and then begin
                update some meta data which
                also have been operated in
                journal:0001
N1 starts, mount
volume, and recover
journal:0001, this
will cover meta data
which N2 has modified,
and then cause filesystem
is destroyed.

So I want to know if someone has a good idea to solve this problem?

Thanks,
Yiwen Jiang.

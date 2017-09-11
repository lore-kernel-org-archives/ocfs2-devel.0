From: Gang He <ghe@suse.com>
Date: Mon, 11 Sep 2017 08:07:29 -0600
Subject: [Ocfs2-devel] [patch]o2net: fix qs_holds may could not be zero
In-Reply-To: <7F50894FD17BEC45AAC26E5BADA6CE330C60AC5B@H3CMLB12-EX.srv.huawei-3com.com>
References: <7F50894FD17BEC45AAC26E5BADA6CE330C60AC5B@H3CMLB12-EX.srv.huawei-3com.com>
Message-ID: <59B6B4C1020000F90008C538@prv-mh.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hello Yang,

Thanks for code submit.
But, could you follow the Linux kernel patch format rule?
How to submit a kernel patch, you can refer the doc https://urldefense.proofpoint.com/v2/url?u=https-3A__www.ozlabs.org_-7Eakpm_stuff_tpp.txt&d=DwIFAg&c=RoP1YumCXCgaWHvlZYR8PQcxBKCX5YTpkKY057SbK10&r=f4ohdmGrYxZejY77yzx3eNgTHb1ZAfZytktjHqNVzc8&m=3nQJc2n3niuZrCBcfTafrMHONl3nSUmUNmSa8O4bs04&s=waaUblcD-UHR0RIXt1Gko92JBn22fbThj1Q0jH65Gy8&e= 

Thanks
Gang


>>> 
> Hi all
> In our test, We fond that , when the network down, qs->qs_holds may could not 
> be reduce to zero, lead to the node can't do fence.
> o2net_idle_timer -> o2quo_conn_err -> qs->qs_holds++, after O2NET_QUORUM_DELAY_MS 
> if qs_holds could be subtract to zero, it could do make_decision.
> But if there are many nodes, when one node network down which contains o2net 
> connections may not do o2net_idle_timer at the same time, so when a 
> o2net_node have done nn->nn_still_up, but the qs_holds is not be zero, because 
> other o2net_node have not done nn->nn_still_up.so the first o2net_node will do 
> o2net_idle_timer again, and the qs_holds could be add again. And the qs_holds 
> is global variable, so it formed a loop, the node could not do 
> o2quo_make_decision, because of qs_holds never be zero.
> 
> I alter two functions o2quo_conn_up and o2quo_conn_err, take o2quo_set_hold 
> or o2quo_clear_hold under control of the bit map qs_conn_bm
> 
> 
> Best Regards,
> Yang Zhang
> 
> 
> @@ -280,20 +280,24 @@ void o2quo_conn_up(u8 node)
>        struct o2quo_state *qs = &o2quo_state;
>         spin_lock(&qs->qs_lock);
> -
> -        qs->qs_connected++;
> -        mlog_bug_on_msg(qs->qs_connected == O2NM_MAX_NODES,
> -                         "node %u\n", node);
> -        mlog_bug_on_msg(test_bit(node, qs->qs_conn_bm), "node %u\n", node);
> -        set_bit(node, qs->qs_conn_bm);
> -
> -        mlog(0, "node %u, %d total\n", node, qs->qs_connected);
> -
> -        if (!test_bit(node, qs->qs_hb_bm))
> -                 o2quo_set_hold(qs, node);
> -        else
> -                 o2quo_clear_hold(qs, node);
> -
> +       if (!test_bit(node, qs->qs_conn_bm)) {
> +                qs->qs_connected++;
> +                mlog_bug_on_msg(qs->qs_connected == O2NM_MAX_NODES,
> +                            "node %u\n", node);
> +                mlog_bug_on_msg(test_bit(node, qs->qs_conn_bm), "node %u\n", 
> node);
> +                set_bit(node, qs->qs_conn_bm);
> +
> +                mlog(0, "node %u, %d total\n", node, qs->qs_connected);
> +
> +                if (!test_bit(node, qs->qs_hb_bm))
> +                          o2quo_set_hold(qs, node);
> +                else
> +                          o2quo_clear_hold(qs, node);
> +       }
>        spin_unlock(&qs->qs_lock);
> }
> @@ -314,13 +318,13 @@ void o2quo_conn_err(u8 node)
>                                    node, qs->qs_connected);
>                  clear_bit(node, qs->qs_conn_bm);
> +
> +                if (test_bit(node, qs->qs_hb_bm))
> +                          o2quo_set_hold(qs, node);
>        }
>         mlog(0, "node %u, %d total\n", node, qs->qs_connected);
> -        if (test_bit(node, qs->qs_hb_bm))
> -                 o2quo_set_hold(qs, node);
> -
>        spin_unlock(&qs->qs_lock);
> }

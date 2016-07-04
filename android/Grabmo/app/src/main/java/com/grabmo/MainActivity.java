package com.grabmo;

import android.app.Fragment;
import android.app.FragmentManager;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;

import com.grabmo.fragment.AccountFragment;
import com.grabmo.fragment.DeviceFragment;
import com.grabmo.fragment.NotificationFragment;
import com.roughike.bottombar.BottomBar;
import com.roughike.bottombar.BottomBarTab;
import com.roughike.bottombar.OnTabClickListener;

public class MainActivity extends AppCompatActivity {

    private FragmentManager fm;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        setAdminLook(savedInstanceState);

    }

    private void setAdminLook(Bundle savedInstanceState) {

        fm = getFragmentManager();

        BottomBar mBottomBar = BottomBar.attach(this, savedInstanceState);

        mBottomBar.setItems(
                new BottomBarTab(R.drawable.devices, getResources().getString(R.string.tab_devices)),
                new BottomBarTab(R.drawable.notifications, getResources().getString(R.string.tab_notifications)),
                new BottomBarTab(R.drawable.user, getResources().getString(R.string.tab_user))
        );

        mBottomBar.setOnTabClickListener(tabListener);

    }

    private OnTabClickListener tabListener = new OnTabClickListener() {
        @Override
        public void onTabSelected(int position) {

            Fragment fragment;

            switch (position) {
                case 0:
                    fragment = new DeviceFragment();
                    if (fm.findFragmentByTag("one") != null) {
                        fm.beginTransaction().show(fm.findFragmentByTag("one")).commit();
                    } else {
                        fm.beginTransaction().add(R.id.main_fragment, fragment, "one").commit();
                    }

                    if (fm.findFragmentByTag("two") != null) {
                        fm.beginTransaction().hide(fm.findFragmentByTag("two")).commit();
                    }

                    if (fm.findFragmentByTag("three") != null) {
                        fm.beginTransaction().hide(fm.findFragmentByTag("three")).commit();
                    }
                    break;
                case 1:
                    fragment = new NotificationFragment();
                    if (fm.findFragmentByTag("two") != null) {
                        fm.beginTransaction().show(fm.findFragmentByTag("two")).commit();
                    } else {
                        fm.beginTransaction().add(R.id.main_fragment, fragment, "two").commit();
                    }

                    if (fm.findFragmentByTag("one") != null) {
                        fm.beginTransaction().hide(fm.findFragmentByTag("one")).commit();
                    }

                    if (fm.findFragmentByTag("three") != null) {
                        fm.beginTransaction().hide(fm.findFragmentByTag("three")).commit();
                    }
                    break;
                case 2:
                    fragment = new AccountFragment();
                    if (fm.findFragmentByTag("three") != null) {
                        fm.beginTransaction().show(fm.findFragmentByTag("three")).commit();
                    } else {
                        fm.beginTransaction().add(R.id.main_fragment, fragment, "three").commit();
                    }

                    if (fm.findFragmentByTag("one") != null) {
                        fm.beginTransaction().hide(fm.findFragmentByTag("one")).commit();
                    }

                    if (fm.findFragmentByTag("two") != null) {
                        fm.beginTransaction().hide(fm.findFragmentByTag("two")).commit();
                    }
                    break;
                default:
                    break;
            }
        }

        @Override
        public void onTabReSelected(int position) {

        }
    };
}
